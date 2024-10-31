import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Banking/DepositScreen.dart';
import 'package:myapp/Banking/WithdrawScreen.dart';
import 'package:myapp/Controller/HomeController.dart';
import 'package:myapp/Screen/ProfileScreen.dart';
import 'package:myapp/Screen/UmkmSearchScreen.dart'; 
import 'newsscreen.dart';

class WelcomeScreen extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>(); // Mengambil instance HomeController

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
