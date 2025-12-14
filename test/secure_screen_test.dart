import 'package:flutter_test/flutter_test.dart';
import 'package:secure_screen/secure_screen.dart';

void main() {
  group('SecureScreen', () {
    test('initial state is not restricted', () {
      final controller = SecureScreen();
      expect(controller.isSecure, false);
    });
  });
}
