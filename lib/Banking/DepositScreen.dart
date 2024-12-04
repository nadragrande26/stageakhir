import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Controller/HomeController.dart';

class DepositScreen extends StatelessWidget {
  final HomeController homeController =
      Get.find<HomeController>(); // Mengambil instance HomeController
  final TextEditingController amountController = TextEditingController();
  XFile? imageFile; // Menyimpan file gambar yang dipilih

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      Get.snackbar('Sukses', 'Gambar berhasil dipilih: ${imageFile!.name}');
    } else {
      Get.snackbar('Error', 'Gambar tidak dipilih!');
    }
  }

  Future<void> _uploadImage() async {
    if (imageFile != null) {
      try {
        // Mendapatkan reference ke Firebase Storage
        FirebaseStorage storage = FirebaseStorage.instance;
        
        // Menggunakan nama file yang unik
        String fileName = 'deposits/${DateTime.now().millisecondsSinceEpoch}_${imageFile!.name}';
        File file = File(imageFile!.path);

        // Upload file
        await storage.ref(fileName).putFile(file);
        Get.snackbar('Sukses', 'Gambar berhasil diupload ke Firebase Storage!');
      } catch (e) {
        Get.snackbar('Error', 'Gagal mengupload gambar: $e');
      }
    } else {
      Get.snackbar('Error', 'Pilih gambar terlebih dahulu!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Deposit',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage, // Panggil fungsi untuk memilih gambar
              child: const Text('Pilih Bukti Deposit'),
            ),
            const SizedBox(height: 20),
            if (imageFile != null) // Tampilkan gambar jika ada
              Column(
                children: [
                  Image.file(
                    File(imageFile!.path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ElevatedButton(
              onPressed: () async {
                // Logika deposit
                if (amountController.text.isNotEmpty && imageFile != null) {
                  int amount = int.parse(amountController.text);
                  homeController.balance.value += amount; // Menambahkan saldo
                  await _uploadImage(); // Upload gambar ke Firebase Storage
                  Get.back(); // Kembali ke halaman utama
                  Get.snackbar('Sukses', 'Deposit berhasil sebesar Rp $amount');
                } else {
                  Get.snackbar('Error',
                      'Masukkan jumlah yang valid dan pilih gambar bukti deposit!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Deposit'),
            ),
          ],
        ),
      ),
    );
  }
}
