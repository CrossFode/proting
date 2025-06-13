import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tubes/Home/ContactUs.dart';
import 'package:tubes/Home/EditProfile.dart';
import 'package:tubes/sreens/login.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  String userName = 'Loading...';
  String userEmail = '';
  String profilePicture =
      'https://i.stack.imgur.com/l60Hf.png'; // default image
  bool isLoading = true;

  // ✅ Perbaikan URL base yang salah
  String baseUrl = 'http://10.0.2.2:3000';
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('user_data');
      String? token = prefs.getString('token');

      if (userDataString != null && token != null) {
        Map<String, dynamic> userData = json.decode(userDataString);

        if (userData['id'] == null) throw 'User ID tidak ditemukan';

        final response = await http.get(
          Uri.parse('$baseUrl/api/Account/${userData['id']}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> userInfo = json.decode(response.body);
          setState(() {
            userId = userData['id'];
            userName = userInfo['username'] ?? 'Unknown User';
            userEmail = userInfo['email'] ?? '';

            String? profilePic = userInfo['profile_picture'];
            if (profilePic != null && profilePic.isNotEmpty) {
              profilePicture = _buildProfilePictureUrl(profilePic);
            }

            isLoading = false;
          });
        } else {
          // fallback to saved data if API fails
          setState(() {
            userId = userData['id'];
            userName = userData['username'] ?? 'Unknown User';
            userEmail = userData['email'] ?? '';

            String? profilePic = userData['profile_picture'];
            if (profilePic != null && profilePic.isNotEmpty) {
              profilePicture = _buildProfilePictureUrl(profilePic);
            }

            isLoading = false;
          });
        }
      } else {
        // Jika tidak ada data user, redirect ke login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        userName = 'Error loading data';
        isLoading = false;
      });
    }
  }

  String _buildProfilePictureUrl(String profilePic) {
    if (profilePic.startsWith('/images/')) {
      return '$baseUrl$profilePic';
    } else if (profilePic.startsWith('http')) {
      return profilePic;
    } else {
      return '$baseUrl/images/$profilePic';
    }
  }

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.remove('token');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/lapar.png'),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      isLoading
                          ? const CircularProgressIndicator()
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(profilePicture),
                              onBackgroundImageError: (exception, stackTrace) {
                                setState(() {
                                  profilePicture =
                                      'https://i.stack.imgur.com/l60Hf.png';
                                });
                              },
                            ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (userEmail.isNotEmpty)
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'General',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.create),
                          title: const Text('Edit Profile'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            if (userId == null) return;
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfilePage(userId: userId!),
                              ),
                            );
                            if (result == true) {
                              _loadUserData();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const ListTile(
                          leading: Icon(Icons.lock),
                          title: Text('Change Password'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'More',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('Contact Us'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUs(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading:
                              const Icon(Icons.logout, color: Colors.red),
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.black),
                          onTap: _logout,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
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
