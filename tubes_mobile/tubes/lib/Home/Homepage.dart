import 'package:flutter/material.dart';
import 'package:tubes/Home/donate/donProto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:carousel_slider/carousel_slider.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  Future<List<dynamic>> fetchCampaigns() async {
    final response =
        await http.get(Uri.parse('http://192.168.100.7:3000/api/campaigns'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load campaigns');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          // Gradient background container
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // Start of the gradient
              end: Alignment.bottomCenter, // End of the gradient
              colors: [
                Color.fromARGB(255, 255, 245, 107),
                // Starting color
                Color.fromARGB(255, 247, 247, 247), // Ending color
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0), // Add some space between widgets
                Trending(), // Display Trending
                TrEvent(), // Display TrEvent widget with the slider
                FutureBuilder<List<dynamic>>(
                  future: fetchCampaigns(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return BottomBox(campaigns: snapshot.data ?? []);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Trending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0), // Optional: add padding
      child: const Text(
        'Trending Now', // Your text
        style: TextStyle(
          fontSize: 20.0, // Font size
          fontWeight: FontWeight.bold, // Font weight
          color: Colors.black, // Text color
        ),
      ),
    );
  }
}

class TrEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: 500,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/headline.png', // Lokasi file gambar di folder assets
          fit: BoxFit.cover, // Agar gambar memenuhi box
        ),
      ),
    );
  }
}

class BottomBox extends StatelessWidget {
  final List<dynamic> campaigns;

  const BottomBox({Key? key, required this.campaigns}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: campaigns.map((campaign) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                campaign['name'], // Display campaign name
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                campaign['description'], // Display campaign description
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Goal: \Rp.${campaign['goal_amount']}', // Display goal amount
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Current: \Rp.${campaign['current_amount']}', // Display current amount
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Donproto(
                                  name: campaign['name'],
                                  description: campaign['description'],
                                )),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 243, 233, 33),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Donate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
