import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  String _filePath = ''; // Menyimpan path gambar/video

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inisialisasi kamera
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.high,
    );

    try {
      await _controller.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  // Fungsi untuk mengambil foto
  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) return;

    try {
      final directory = await getExternalStorageDirectory();
      final photoPath = path.join(directory!.path, 'Photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
      XFile picture = await _controller.takePicture();

      // Pindahkan file ke path yang ditentukan
      final File photoFile = File(photoPath);
      await picture.saveTo(photoFile.path);

      setState(() {
        _filePath = photoFile.path;
      });

      print("Photo saved to: $_filePath");
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  // Fungsi untuk memulai atau menghentikan perekaman video
  Future<void> _toggleRecording() async {
    if (!_controller.value.isInitialized) return;

    try {
      Directory moviesDirectory = Directory('/storage/emulated/0/Movies');
      if (!await moviesDirectory.exists()) {
        await moviesDirectory.create(recursive: true); // Buat folder jika belum ada
      }

      final videoPath = path.join(moviesDirectory.path, 'Video_${DateTime.now().millisecondsSinceEpoch}.mp4');

      if (_isRecording) {
        // Hentikan perekaman
        XFile videoFile = await _controller.stopVideoRecording();

        // Pindahkan file ke Movies
        await videoFile.saveTo(videoPath);
        setState(() {
          _isRecording = false;
          _filePath = videoPath;
        });

        print("Video saved to: $_filePath");
      } else {
        // Mulai perekaman
        await _controller.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      print("Error with video recording: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Camera')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Picture'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ),
          if (_filePath.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _filePath.endsWith('.mp4')
                  ? Text('Video saved to: $_filePath') // Menampilkan path video
                  : Image.file(File(_filePath)), // Menampilkan foto
            ),
        ],
      ),
    );
  }
}
