import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import ini diperlukan untuk TextInputFormatter
import 'package:tubes/Home/Profilepage.dart';

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
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Message sent successfully!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_firstNameController.text.isEmpty) {
      _showErrorSnackBar('Please enter your first name');
      return;
    }
    if (_lastNameController.text.isEmpty) {
      _showErrorSnackBar('Please enter your last name');
      return;
    }
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }
    if (_messageController.text.isEmpty) {
      _showErrorSnackBar('Please enter your message');
      return;
    }

    _showSuccessSnackBar();

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
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            title: const Text('Contact Us'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profilepage()),
                );
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType:
                    TextInputType.number, // Menampilkan keyboard numerik
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Hanya menerima angka
                  LengthLimitingTextInputFormatter(
                      13), // Membatasi panjang input
                ],
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter your phone number', // Hint text optional
                  prefixText: '+62 ', // Menambahkan prefix +62
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleSubmit,
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
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
