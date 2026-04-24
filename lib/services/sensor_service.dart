import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SensorService {
  Stream<String> accelerometer() {
    return accelerometerEvents.map((e) =>
        "x:${e.x.toStringAsFixed(1)} y:${e.y.toStringAsFixed(1)} z:${e.z.toStringAsFixed(1)}");
  }

  Stream<String> gyroscope() {
    return gyroscopeEvents.map((e) =>
        "x:${e.x.toStringAsFixed(1)} y:${e.y.toStringAsFixed(1)} z:${e.z.toStringAsFixed(1)}");
  }

  Stream<String> magnetometer() {
    return magnetometerEvents.map((e) =>
        "x:${e.x.toStringAsFixed(1)} y:${e.y.toStringAsFixed(1)} z:${e.z.toStringAsFixed(1)}");
  }

  Future<String> getLocation() async {
    await Geolocator.requestPermission();
    Position pos = await Geolocator.getCurrentPosition();
    return "${pos.latitude}, ${pos.longitude}";
  }

  Future<String> getBattery() async {
    final battery = Battery();
    int level = await battery.batteryLevel;
    return "$level%";
  }

  Future<String> getConnection() async {
    var result = await Connectivity().checkConnectivity();
    return result.toString();
  }

  Future<String> getDevice() async {
    final deviceInfo = DeviceInfoPlugin();
    var android = await deviceInfo.androidInfo;
    return "${android.brand} ${android.model}";
  }
}