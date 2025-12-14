import 'package:flutter_test/flutter_test.dart';
import 'package:secure_display/secure_display.dart';

void main() {
  group('SecureScreen', () {
    test('initial state is not restricted', () {
      final controller = SecureScreen();
      expect(controller.isSecure, false);
    });
  });
}

