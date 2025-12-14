import 'package:get/get.dart';
import 'package:secure_display/secure_display.dart';

/// Controller for Controller Example Page
class ControllerExampleController extends GetxController {
  late SecureScreenController secureScreenController;

  @override
  void onInit() {
    super.onInit();
    secureScreenController = Get.put(SecureScreenController());
  }

  @override
  void onClose() {
    Get.delete<SecureScreenController>();
    super.onClose();
  }
}
