import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:myapp/Akun/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  _startSplashScreen() async {
    var duration = const Duration(seconds: 2);
    Timer(duration, () {
      // Setelah 2 detik, pindah ke halaman Login
      Get.offAll(() => LoginScreen()); // Gunakan Get.offAll untuk mengganti semua halaman
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.keyboard_double_arrow_up_rounded, size: 100.0, color: Colors.white),
            SizedBox(height: 24.0),
            Text(
              "INVEST YUK",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          ],
        ),
      ),
    );
  }
}
