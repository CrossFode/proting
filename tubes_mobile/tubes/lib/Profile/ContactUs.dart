import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact Us',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactUsPage(),
    );
  }
}

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Function to submit the form
  Future<void> _submitForm() async {
    final url = Uri.parse('http://127.0.0.1:3000/api/contact_us');
    // 'http://192.168.100.12:/api/contact_us');
    final body = {
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'phone_number': _phoneController.text,
      'message': _messageController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent successfully!')),
        );
        _clearForm();
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  // Function to clear the form
  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // Tinggi AppBar
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              // Menambahkan drop shadow di bawah AppBar
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Warna bayangan
                spreadRadius: 2, // Radius sebaran
                blurRadius: 6, // Radius blur bayangan
                offset: const Offset(
                    0, 3), // Posisi bayangan (horizontal, vertical)
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Contact Us'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Ikon panah kembali
              onPressed: () {
                Navigator.pop(
                    context); // Aksi kembali ke halaman sebelumnya (ProfilePage)
              },
            ),
            backgroundColor: Colors.white, // Warna background AppBar
            elevation: 0, // Hilangkan bayangan bawaan AppBar
            titleTextStyle: const TextStyle(
              color: Colors.black, // Warna teks AppBar
              fontSize: 20, // Ukuran teks
            ),
            iconTheme: const IconThemeData(color: Colors.black), // Warna ikon
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Message is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
