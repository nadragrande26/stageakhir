import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Controller/HomeController.dart';
import 'package:myapp/main.dart';

class UmkmSearchScreen extends StatelessWidget {
  final HomeController homeController =
      Get.find<HomeController>(); // Mengambil instance HomeController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari UMKM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return ListView.builder(
            itemCount: homeController.umkms.length,
            itemBuilder: (context, index) {
              UMKM umkm = homeController.umkms[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(umkm.name),
                  subtitle: Text(
                      'Lokasi: ${umkm.location}\nPerforma: ${umkm.performance}'),
                  isThreeLine: true,
                  onTap: () {
                    _showInvestmentDialog(context, umkm);
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _showInvestmentDialog(BuildContext context, UMKM umkm) {
    final TextEditingController investmentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Investasi pada ${umkm.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Lokasi: ${umkm.location}'),
              Text('Performa: ${umkm.performance}'),
              TextField(
                controller: investmentController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Investasi',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                int investmentAmount =
                    int.tryParse(investmentController.text) ?? 0;
                if (investmentAmount > 0) {
                  Get.find<HomeController>().balance.value -=
                      investmentAmount; // Mengurangi saldo
                  Get.back(); // Menutup dialog
                  Get.snackbar('Sukses',
                      'Investasi sebesar Rp $investmentAmount telah berhasil dilakukan pada ${umkm.name}!');
                } else {
                  Get.snackbar('Error', 'Masukkan jumlah yang valid!');
                }
              },
              child: const Text('Investasi'),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Menutup dialog
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }
}