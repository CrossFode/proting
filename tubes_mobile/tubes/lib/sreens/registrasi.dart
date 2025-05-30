import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tubes/sreens/lupa.dart';
import 'package:tubes/sreens/opening.dart';
import 'package:tubes/sreens/login.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _passwordError;
  bool _obscurePassword = true;

  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username is required.';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long.';
    }
    return null;
  }

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
    if (value.length < 8 || value.length > 16) {
      return 'Password must be 8-16 characters long.';
    }

    bool hasUppercase = false;
    bool hasSpecialCharacter = false;
    const specialCharacters = '!@#\$%^&*(),.?":{}|<>';
    for (int i = 0; i < value.length; i++) {
      if (value[i].toUpperCase() == value[i] &&
          value[i].toLowerCase() != value[i]) {
        hasUppercase = true;
      }
      if (specialCharacters.contains(value[i])) {
        hasSpecialCharacter = true;
      }
    }

    if (!hasUppercase) {
      return 'Password must include at least one uppercase letter.';
    }
    if (!hasSpecialCharacter) {
      return 'Password must include at least one special character.';
    }
    return null;
  }

  void _onSubmit() async {
    print("Username: ${_usernameController.text}");
    print("Password: ${_passwordController.text}");
    if (_formKey.currentState?.validate() ?? false) {
      final password = _passwordController.text;
      if (password != _confirmPasswordController.text) {
        setState(() {
          _passwordError = 'Passwords do not match.';
        });
        return;
      }

      setState(() {
        _passwordError = null;
      });

      // Data untuk registrasi
      final Map<String, dynamic> data = {
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      try {
        // Kirim data ke API
        const String BASE_URL =
            "http://127.0.0.1:3000"; // Ganti dengan URL backend Anda
        final response = await http.post(
          Uri.parse('$BASE_URL/api/Account/registrasi'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          final contentType = response.headers['content-type'];
          if (contentType != null && contentType.contains('application/json')) {
            final errorMessage =
                jsonDecode(response.body)['error'] ?? 'Registration failed';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $errorMessage')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Error: Unexpected response format')),
            );
          }
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print("catch $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _launchFacebook() async {
    const url =
        'https://www.facebook.com/YourPage'; // Ganti dengan URL halaman Facebook Anda
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColorfulSafeArea(
        color: const Color.fromARGB(255, 245, 245, 246),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 0),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Ellipse7.png',
                        width: 160,
                        height: 164,
                      ),
                      SizedBox(height: 10),
                      Text(
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
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 24,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 0),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, top: 20),
                    child: Text(
                      'Username',
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
                      controller: _usernameController,
                      validator: (value) => _validateUsername(value ?? ''),
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
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Color.fromARGB(255, 152, 152, 152),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, top: 20),
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
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Color.fromARGB(255, 152, 152, 152),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, top: 10),
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
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Color.fromARGB(255, 152, 152, 152),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, top: 10),
                    child: Text(
                      'Konfirmasi Kata Sandi',
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
                      controller: _confirmPasswordController,
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
                        hintText: 'Re-type New Password',
                        hintStyle: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 12,
                          color: Color.fromARGB(255, 152, 152, 152),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 253, 194, 0)),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255)),
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
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: Color.fromARGB(255, 0, 0, 0),
                            side: BorderSide(color: Colors.grey, width: 1),
                          ),
                          onPressed: () {},
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
                              Padding(
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
                                  Color.fromARGB(255, 255, 255, 255),
                              foregroundColor: Color.fromARGB(255, 0, 0, 0),
                              side: BorderSide(color: Colors.grey, width: 1),
                            ),
                            onPressed: _launchFacebook,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By registering you agree to the ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color.fromARGB(255, 92, 78, 78),
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 92, 78, 78),
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
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
