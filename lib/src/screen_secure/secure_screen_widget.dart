import 'package:flutter/widgets.dart';
import 'secure_screen.dart';

/// A widget that automatically applies screen restriction when mounted
/// and removes it when unmounted from the widget tree.
///
/// This widget wraps its child and manages the screen restriction lifecycle
/// automatically. When the widget is added to the tree, screen restriction
/// is activated. When removed, it's automatically disposed.
///
/// Example:
/// ```dart
/// SecureScreenWidget(
///   child: Scaffold(
///     appBar: AppBar(title: Text('Secure Page')),
///     body: Text('This screen is protected'),
///   ),
/// )
/// ```
class SecureScreenWidget extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// If true, uses a blur overlay instead of FLAG_SECURE.
  /// Use this if FLAG_SECURE doesn't work on your device.
  /// Defaults to false.
  final bool useBlur;

  /// Creates a widget that automatically manages screen restriction.
  ///
  /// The [child] argument is required and must not be null.
  const SecureScreenWidget({
    super.key,
    required this.child,
    this.useBlur = false,
  });

  @override
  State<SecureScreenWidget> createState() => _SecureScreenWidgetState();
}

class _SecureScreenWidgetState extends State<SecureScreenWidget> {
  SecureScreen? _secureScreen;

  @override
  void initState() {
    super.initState();
    _initializeRestriction();
  }

  Future<void> _initializeRestriction() async {
    try {
      _secureScreen = SecureScreen();
      await _secureScreen!.activate(useBlur: widget.useBlur);
    } catch (e) {
      // Error occurred during initialization
      // The restriction may not be active, but we continue
      // The child widget will still be rendered
    }
  }

  @override
  void dispose() {
    _secureScreen?.dispose();
    _secureScreen = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
