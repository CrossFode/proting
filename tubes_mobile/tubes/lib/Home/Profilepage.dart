import 'package:flutter/material.dart';
import 'package:tubes/Profile/ContactUs.dart';
import 'package:tubes/Profile/EditProfile.dart';
import 'package:tubes/sreens/login.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(), // Pastikan memenuhi layar
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/lapar.png'), // Gambar latar belakang
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  const Column(
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/user.png', // Gambar profil dari assets
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Jhon Doe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
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
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit Profile'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfile(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
