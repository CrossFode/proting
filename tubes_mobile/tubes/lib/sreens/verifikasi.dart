import 'dart:convert'; // Untuk JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Verifikasi extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Verifikasi({Key? key}) : super(key: key);

  Future<void> _requestResetPassword(BuildContext context) async {
    final email = emailController.text.trim();

    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:3000/request-reset-password'), // URL API Anda
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Jika permintaan berhasil
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['msg']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Jika terjadi error (404 atau lainnya)
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['msg']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Tangani error lainnya (misalnya koneksi gagal)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Lupa Kata Sandi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Masukkan email untuk mengatur ulang kata sandi.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan email Anda',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _requestResetPassword(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Verifikasi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
