import 'dart:async';
import 'package:secure_display/secure_display.dart';

/// Controller for Bank Details Page
class BankDetailsController {
  late SecureScreen _restrictionController;
  final _isInitializedController = StreamController<bool>.broadcast();
  bool _isInitialized = false;

  Stream<bool> get isInitializedStream => _isInitializedController.stream;
  bool get isInitialized => _isInitialized;

  BankDetailsController() {
    _restrictionController = SecureScreen();
  }

  /// Initialize screen restriction
  ///
  /// [useBlur] - If true, uses a blur overlay instead of FLAG_SECURE.
  ///              Use this if FLAG_SECURE doesn't work on your device.
  ///              Defaults to false.
  Future<void> initializeRestriction({bool useBlur = false}) async {
    try {
      await _restrictionController.activate(useBlur: useBlur);
      _isInitialized = true;
      _isInitializedController.add(_isInitialized);
    } catch (e) {
      _isInitialized = false;
      _isInitializedController.add(_isInitialized);
      // Error handling can be done at the UI level
      rethrow;
    }
  }

  void dispose() {
    _restrictionController.dispose();
    _isInitializedController.close();
  }
}
