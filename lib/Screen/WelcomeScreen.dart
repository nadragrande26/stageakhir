import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Banking/DepositScreen.dart';
import 'package:myapp/Banking/WithdrawScreen.dart';
import 'package:myapp/Controller/HomeController.dart';
import 'package:myapp/Screen/CameraScreen.dart';
import 'package:myapp/Screen/MicrophoneScreen.dart';
import 'package:myapp/Screen/ProfileScreen.dart';
import 'package:myapp/Screen/SpeakerScreen.dart';
import 'package:myapp/Screen/UmkmSearchScreen.dart';
import 'newsscreen.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:geocoding/geocoding.dart'; // Import Geocoding

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final HomeController homeController = Get.find<HomeController>(); // Mengambil instance HomeController
  String _location = 'Mencari lokasi...'; // Menyimpan lokasi
  String _coordinates = ''; // Menyimpan koordinat

  @override
  void initState() {
    super.initState();
    _getLocation(); // Mendapatkan lokasi saat halaman pertama kali dibuat
  }

  // Fungsi untuk mendapatkan lokasi pengguna
  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Memeriksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = 'Layanan lokasi tidak aktif.';
      });
      return;
    }

    // Memeriksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Meminta izin
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _location = 'Izin lokasi ditolak.';
        });
        return;
      }
    }

    // Mendapatkan posisi pengguna setelah izin diberikan
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Mendapatkan nama kota berdasarkan koordinat
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    setState(() {
      _coordinates = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      _location = '${place.locality}: ${_coordinates}'; // Menampilkan nama kota dan koordinat
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda - InvestYuk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(() => Text(
                  'Selamat Datang, ${homeController.username.value}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                )),
            const SizedBox(height: 20),
            Obx(() => Text(
                  'Saldo Anda: Rp ${homeController.balance.value}',
                  style: const TextStyle(fontSize: 20),
                )),
            const SizedBox(height: 20),
            Text(
              _location, // Menampilkan lokasi kota dan koordinat pengguna
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Get.to(DepositScreen());
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.attach_money, size: 50, color: Colors.green),
                            SizedBox(height: 10),
                            Text(
                              'Deposit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(WithdrawScreen());
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.money_off, size: 50, color: Colors.red),
                            SizedBox(height: 10),
                            Text(
                              'Withdraw',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(NewsScreen());
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.article, size: 50, color: Colors.blue),
                            SizedBox(height: 10),
                            Text(
                              'Berita',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(UmkmSearchScreen());
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.business_center, size: 50, color: Colors.orange),
                            SizedBox(height: 10),
                            Text(
                              'UMKM',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(CameraScreen());
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.camera, size: 50, color: Colors.blue),
                            SizedBox(height: 10),
                            Text(
                              'Camera',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(MicrophoneScreen());
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.mic, size: 50, color: Colors.green),
                            SizedBox(height: 10),
                            Text(
                              'Microphone',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(SpeakerScreen());
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.volume_up, size: 50, color: Colors.red),
                            SizedBox(height: 10),
                            Text(
                              'Speaker',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: homeController.currentIndex.value,
        selectedItemColor: Colors.green,
        onTap: (int index) {
          homeController.currentIndex.value = index; // Update indeks halaman
          switch (index) {
            case 0:
              Get.off(WelcomeScreen());
              break;
            case 1:
              Get.to(UmkmSearchScreen());
              break;
            case 2:
              Get.to(ProfileScreen());
              break;
          }
        },
      ),
    );
  }
}
