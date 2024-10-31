import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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

                  // Mencoba login pengguna dengan email dan password
                  UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  if (userCredential.user != null) {
                    Get.snackbar('Login', 'Login berhasil!');
                    // Arahkan ke WelcomeScreen
                    Get.offNamed('/welcome');
                  }
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
              child: const Text('Masuk'),
            ),
            TextButton(
              onPressed: () {
                Get.offNamed('/register'); // Pindah ke RegisterScreen
              },
              child: const Text('Belum punya akun? Daftar di sini.'),
            ),
          ],
        ),
      ),
    );
  }
}
