import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  // Mendaftar pengguna dengan email dan password
                  await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  Get.snackbar('Pendaftaran', 'Registrasi berhasil! Silakan login.');
                  Get.offAllNamed('/'); // Kembali ke LoginScreen
                } catch (e) {
                  Get.snackbar('Error', e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Daftar'),
            ),
            TextButton(
              onPressed: () {
                Get.offNamed('/'); // Pindah ke LoginScreen
              },
              child: const Text('Sudah punya akun? Masuk di sini.'),
            ),
          ],
        ),
      ),
    );
  }
}
