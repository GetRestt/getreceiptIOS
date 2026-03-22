import 'package:flutter/services.dart';

class DeviceSecurity {
  static const MethodChannel _channel =
  MethodChannel('device_security');

  static Future<bool> isDeviceCompromised() async {
    try {
      final bool compromised =
      await _channel.invokeMethod('checkDeviceSecurity');
      return compromised;
    } catch (e) {
      return true; // Fail-safe: block access
    }
  }
}
