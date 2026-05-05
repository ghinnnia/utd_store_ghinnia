import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BatteryService {
  static const MethodChannel _channel = MethodChannel('battery');

  static Future<int> getBatteryLevel() async {
    try {
      final int battery = await _channel.invokeMethod('getBattery');
      return battery;
    } on PlatformException {
      return -1;
    }
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}