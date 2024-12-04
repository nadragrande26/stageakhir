import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
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
                  title: Text(umkm.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lokasi: ${umkm.location}', style: TextStyle(fontSize: 14)),
                      Text('Performa: ${umkm.performance}', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.blue),
                    onPressed: () {
                      _openLocationInMaps(umkm.mapsUrl); // Gunakan mapsUrl
                    },
                  ),
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
          title: Text('Investasi pada ${umkm.name}', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Lokasi: ${umkm.location}', style: TextStyle(fontSize: 14)),
              Text('Performa: ${umkm.performance}', style: TextStyle(fontSize: 14)),
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
                int investmentAmount = int.tryParse(investmentController.text) ?? 0;
                if (investmentAmount > 0) {
                  Get.find<HomeController>().balance.value -= investmentAmount; // Mengurangi saldo
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

  void _openLocationInMaps(String mapsUrl) async {
    final Uri googleMapsUrl = Uri.parse(mapsUrl); // Gunakan URL dari parameter
    
    if (await canLaunch(googleMapsUrl.toString())) {
      await launch(googleMapsUrl.toString());
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka Google Maps');
    }
  }
}
