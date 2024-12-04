
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/Controller/HomeController.dart';


class WithdrawScreen extends StatelessWidget {
  final HomeController homeController =
      Get.find<HomeController>(); // Mengambil instance HomeController
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Daftar bank untuk dropdown
  final List<String> banks = ['BCA', 'BNI', 'Mandiri', 'BRI'];
  String? selectedBank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Input untuk Nama Pemilik Rekening
            TextField(
              controller: accountNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Pemilik Rekening',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Dropdown untuk Memilih Jenis Bank
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Pilih Bank',
                border: OutlineInputBorder(),
              ),
              items: banks.map((String bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              onChanged: (String? value) {
                // Menyimpan pilihan bank
                selectedBank = value;
              },
              value: selectedBank,
              isExpanded: true,
              hint: const Text('Pilih Bank'), // Placeholder
            ),
            const SizedBox(height: 20),
            // Input untuk Jumlah Withdraw
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Withdraw',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Tombol Withdraw
            ElevatedButton(
              onPressed: () {
                // Logika withdraw
                if (accountNameController.text.isNotEmpty &&
                    selectedBank != null &&
                    amountController.text.isNotEmpty) {
                  int amount = int.parse(amountController.text);
                  if (amount <= homeController.balance.value) {
                    homeController.balance.value -= amount; // Mengurangi saldo
                    Get.back(); // Kembali ke halaman utama
                    Get.snackbar('Sukses',
                        'Withdraw sebesar Rp $amount ke rekening ${accountNameController.text} di bank $selectedBank berhasil.');
                  } else {
                    Get.snackbar('Error', 'Saldo tidak cukup!');
                  }
                } else {
                  Get.snackbar('Error', 'Mohon lengkapi semua field!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Withdraw'),
            ),
          ],
        ),
      ),
    );
  }
}
