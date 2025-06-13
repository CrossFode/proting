import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tubes/Home/Historypage.dart';
import 'package:tubes/Home/Homepage.dart';
import 'package:tubes/sreens/lupa.dart';
import 'package:tubes/sreens/registrasi.dart';
import 'package:flutter/gestures.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tubes/sreens/verifikasi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;
  bool _obscurePassword = true;
  bool _isLoading = false; // Add loading state

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required.';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address.';
    }
    if (value.startsWith('@') || value.endsWith('@') || value.endsWith('.')) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required.';
    }
    return null;
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading
      });

      final String email = _emailController.text;
      final String password = _passwordController.text;

      // Data untuk login
      final Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };

      try {
        const String BASE_URL =
            "http://10.0.2.2:3000"; // Sesuaikan dengan URL backend Anda
        final response = await http.post(
          Uri.parse('$BASE_URL/api/Account/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );

        setState(() {
          _isLoading = false; // Hide loading
        });

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          // Pastikan response memiliki struktur yang benar
          if (responseData.containsKey('user') &&
              responseData.containsKey('token')) {
            final Map<String, dynamic> userData = responseData['user'];
            final String token = responseData['token'];

            // Simpan data ke SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('user_data', jsonEncode(userData));
            await prefs.setString('token', token);

            // Debug: Print data yang disimpan
            print('Saved user data: ${jsonEncode(userData)}');
            print('Saved token: $token');

            // Tampilkan dialog login berhasil
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Login Successful"),
                content:
                    Text("Welcome back, ${userData['username'] ?? 'User'}!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      // Navigasi ke main page
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          } else {
            // Handle jika struktur response tidak sesuai
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Invalid response structure from server')),
            );
          }
        } else {
          print('Login failed with status code: ${response.statusCode}');
          print('Response body: ${response.body}');

          String errorMessage = 'Login failed';
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['error'] ?? errorMessage;
          } catch (e) {
            print('Error parsing error response: $e');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $errorMessage')),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading
        });

        print('Login error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
    }
  }

  void _launchFacebook() async {
    const url = 'https://www.facebook.com/YourPage';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 0),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Ellipse7.png',
                      width: 160,
                      height: 164,
                    ),
                    const Text(
                      'LAPER\nPAK!!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'ZhiMangXing',
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 24,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 0),
                const Padding(
                  padding: EdgeInsets.only(right: 16, left: 16, top: 20),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color.fromARGB(255, 76, 76, 76),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) => _validateEmail(value ?? ''),
                    enabled: !_isLoading, // Disable saat loading
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1.0,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1.0,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 12,
                        color: Color.fromARGB(255, 152, 152, 152),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16, left: 16, top: 10),
                  child: Text(
                    'Kata Sandi',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color.fromARGB(255, 76, 76, 76),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: TextFormField(
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    validator: (value) => _validatePassword(value ?? ''),
                    enabled: !_isLoading, // Disable saat loading
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1.0,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1.0,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 12,
                        color: Color.fromARGB(255, 152, 152, 152),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : _login, // Disable saat loading
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 253, 194, 0)),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                  ),
                ),
                const SizedBox(height: 0),
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () {
                          // Navigasi ke halaman lupa password
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Verifikasi()),
                          );
                        },
                  child: Center(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: _isLoading ? Colors.grey : Colors.red,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 2.0,
                          color: Color.fromARGB(252, 217, 217, 217),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          'or',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromARGB(255, 92, 78, 78)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2.0,
                          color: Color.fromARGB(252, 217, 217, 217),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          side: const BorderSide(color: Colors.grey, width: 1),
                        ),
                        onPressed: _isLoading ? null : () {},
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Image.asset(
                                'assets/images/google1.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text(
                                'Google',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 92, 78, 78),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                          ),
                          onPressed: _isLoading ? null : _launchFacebook,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Image.asset(
                                  'assets/images/facebook1.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Expanded(
                                  child: Text(
                                    'Facebook',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 92, 78, 78),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}