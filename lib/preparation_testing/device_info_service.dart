import 'dart:async';
import 'package:flutter/services.dart';

class DeviceInfoService {
  static const _methodChannel = MethodChannel('com.example.device_info/methods');
  static const _eventChannel = EventChannel('com.example.device_info/events');

  /// Get current battery level (one-time call)
  static Future<int?> getBatteryLevel() async {
    try {
      final int? batteryLevel = await _methodChannel.invokeMethod<int>('getBatteryLevel');
      return batteryLevel;
    } on PlatformException catch (e) {
      print('⚠️ Failed to get battery level: ${e.message}');
      return null;
    }
  }

  /// Stream battery state updates (charging, discharging, full)
  static Stream<String> get batteryStateStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }
}
