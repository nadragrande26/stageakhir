import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/Akun/LoginScreen.dart';
import 'package:myapp/Akun/RegisterScreen.dart';
import 'package:myapp/Screen/WelcomeScreen.dart'; // Import WelcomeScreen
import 'package:myapp/Controller/HomeController.dart'; // Import HomeController
import 'package:myapp/Screen/SplashScreen.dart'; // Import SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inisialisasi HomeController dengan Get.put()
  Get.put(HomeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Invest Yuk',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/', // Tetap ke '/' untuk SplashScreen
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()), // Ubah ke SplashScreen
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/welcome', page: () => WelcomeScreen()),
      ],
    );
  }
}

// Kelas UMKM untuk menyimpan informasi UMKM
class UMKM {
  final String name;
  final String location;
  final String performance;
  final String mapsUrl; // Menambahkan properti mapsUrl

  UMKM({
    required this.name,
    required this.location,
    required this.performance,
    required this.mapsUrl, // Sertakan mapsUrl pada konstruktor
  });
}