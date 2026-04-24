import 'package:flutter/material.dart';
import '../services/sensor_service.dart';
import '../widgets/info_card.dart';
import '../utils/app_colors.dart';
import 'camera_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sensor = SensorService();

  String acc = "Loading...";
  String gyro = "Loading...";
  String mag = "Loading...";
  String location = "-";
  String battery = "-";
  String connection = "-";
  String device = "-";

  @override
  void initState() {
    super.initState();

    sensor.accelerometer().listen((v) {
      setState(() => acc = v);
    });

    sensor.gyroscope().listen((v) {
      setState(() => gyro = v);
    });

    sensor.magnetometer().listen((v) {
      setState(() => mag = v);
    });

    loadData();
  }

  void loadData() async {
    location = await sensor.getLocation();
    battery = await sensor.getBattery();
    connection = await sensor.getConnection();
    device = await sensor.getDevice();

    setState(() {});
  }

  String getStatus() {
    if (connection.toLowerCase().contains("wifi") &&
        acc.contains("0.0")) {
      return "Sedang Santai";
    } else {
      return "Sedang Aktif";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Mood Sensor",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.card,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [

          InfoCard(
            title: "Status",
            value: getStatus(),
            description:
                "Menunjukkan aktivitas pengguna berdasarkan sensor.",
            icon: Icons.psychology,
          ),

          InfoCard(
            title: "Accelerometer",
            value: acc,
            description:
                "Mendeteksi percepatan atau gerakan perangkat.",
            icon: Icons.speed,
          ),

          InfoCard(
            title: "Gyroscope",
            value: gyro,
            description:
                "Mendeteksi rotasi atau perubahan arah perangkat.",
            icon: Icons.screen_rotation,
          ),

          InfoCard(
            title: "Magnetometer",
            value: mag,
            description:
                "Berfungsi sebagai kompas untuk menentukan arah.",
            icon: Icons.explore,
          ),

          InfoCard(
            title: "Location",
            value: location,
            description:
                "Menampilkan posisi koordinat pengguna (GPS).",
            icon: Icons.location_on,
          ),

          InfoCard(
            title: "Battery",
            value: battery,
            description:
                "Menampilkan persentase baterai perangkat.",
            icon: Icons.battery_full,
          ),

          InfoCard(
            title: "Connection",
            value: connection,
            description:
                "Menunjukkan jenis koneksi internet yang digunakan.",
            icon: Icons.wifi,
          ),

          InfoCard(
            title: "Device",
            value: device,
            description:
                "Informasi perangkat yang digunakan pengguna.",
            icon: Icons.phone_android,
          ),
        
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CameraPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.card,
              foregroundColor: AppColors.text,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text(
                  "Buka Kamera",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}