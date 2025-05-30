import 'package:flutter/material.dart';
import 'package:tubes/Home/Homepage.dart';

class Donproto extends StatelessWidget {
  final String name;
  final String description;

  const Donproto({Key? key, required this.name, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _donationController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 245, 107),
                Color.fromARGB(255, 247, 247, 247),
              ],
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      backBtn(),
                      SizedBox(height: 20),
                      Container(
                        width: 400,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: _donationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Masukkan Nominal Donasi',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle donation logic here
                                },
                                child: Text('Donate'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 236, 243, 33),
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class backBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        },
      ),
    );
  }
}
