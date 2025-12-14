import 'dart:async';
import 'package:flutter/services.dart';

class SecureScreen {
  static const MethodChannel _channel = MethodChannel(
    'secure_display/screen_secure',
  );
  bool _isRestricted = false;

  bool get isSecure => _isRestricted;

  Future<bool> activate({bool useBlur = false}) async {
    return await _restrict(useBlur: useBlur);
  }

  Future<bool> _restrict({bool useBlur = false}) async {
    try {
      final result = await _channel.invokeMethod<bool>(
            'restrict',
            {'useBlur': useBlur},
          ) ??
          false;
      _isRestricted = result;
      return result;
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to restrict screen recording: ${e.message}',
        details: e.details,
      );
    }
  }

  Future<bool> _unrestrict() async {
    try {
      final result = await _channel.invokeMethod<bool>('unrestrict') ?? false;
      _isRestricted = !result;
      return result;
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to unrestrict screen recording: ${e.message}',
        details: e.details,
      );
    }
  }

  Future<void> dispose() async {
    if (_isRestricted) {
      await _unrestrict();
    }
  }
}
