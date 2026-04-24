import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../utils/app_colors.dart';

List<CameraDescription>? cameras;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  XFile? image;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  void initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
      cameras![0],
      ResolutionPreset.medium,
    );
    await controller!.initialize();
    setState(() {});
  }

  Future<void> takePicture() async {
    if (!controller!.value.isInitialized) return;

    final pic = await controller!.takePicture();

    setState(() {
      image = pic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Camera",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.card,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.text),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            controller != null && controller!.value.isInitialized
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: CameraPreview(controller!),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: takePicture,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.card,
                  foregroundColor: AppColors.text,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  "Ambil Foto",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 20),

            image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(image!.path),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    "Belum ada foto",
                    style: TextStyle(color: AppColors.text),
                  ),
          ],
        ),
      ),
    );
  }
}