import 'package:get/get.dart';
import '../secure_screen.dart';

class SecureScreenController extends GetxController {
  SecureScreen? _secureScreen;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool get isSecure => _secureScreen?.isSecure ?? false;

  final bool useBlur;

  SecureScreenController({this.useBlur = false});

  @override
  Future<void> onInit() async {
    super.onInit();
    if (_isInitialized) {
      return;
    }
    _secureScreen = SecureScreen();
    await _secureScreen!.activate(useBlur: useBlur);
    _isInitialized = true;
  }

  @override
  Future<void> onClose() async {
    if (!_isInitialized) {
      super.onClose();
      return;
    }
    await _secureScreen?.dispose();
    _secureScreen = null;
    _isInitialized = false;
    super.onClose();
  }

  Future<bool> activate() async {
    if (!_isInitialized) {
      await onInit();
      return true;
    }
    return await _secureScreen?.activate(useBlur: useBlur) ?? false;
  }

  Future<bool> deactivate() async {
    if (!_isInitialized) {
      return false;
    }
    await _secureScreen?.dispose();
    return true;
  }
}
