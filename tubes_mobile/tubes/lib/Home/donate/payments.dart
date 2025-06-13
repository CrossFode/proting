import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tubes/Home/Homepage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tubes/main.dart';

class PaymentPage extends StatefulWidget {
  final String campaignId;
  final String campaignName;
  final String donationAmount;

  const PaymentPage({
    Key? key,
    required this.campaignId,
    required this.campaignName,
    required this.donationAmount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String paymentStatus = "NOT PAID";
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> createDonation() async {
    const String apiUrl = "http://10.0.2.2:3000/api/payments";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['campaign_id'] = widget.campaignId;
      request.fields['campaign_name'] = widget.campaignName;
      request.fields['donation_amount'] = widget.donationAmount;
      request.fields['payment_status'] = "PAID";
      request.fields['created_at'] = DateTime.now().toIso8601String();
      request.fields['updated_at'] = DateTime.now().toIso8601String();

      // Jika ada gambar, tambahkan ke request
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'payment_image', // nama field sesuai backend
          _imageFile!.path,
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          setState(() {
            paymentStatus = "PAID";
          });

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text("Berhasil Donasi"),
              content: const Text("Terima kasih atas donasi Anda!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Navbar(initialIndex: 0)),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Payment failed: ${responseData['message'] ?? 'Unknown error'}")),
          );
        }
      } else {
        try {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Failed: ${errorData['message'] ?? errorData['error'] ?? 'Unknown error'}")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: HTTP ${response.statusCode}")),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during payment: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Payment Details"),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Campaign ID",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.campaignId,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Campaign",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                              child: Text(
                                widget.campaignName,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Nominal",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Rp ${widget.donationAmount}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Payment status",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: paymentStatus == "PAID"
                                    ? Colors.green
                                    : Colors.yellow,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                paymentStatus,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
const Text(
  "BCA 6801624674 a.n. NABIEL ASCAR MOCHAMMAD",
  style: TextStyle(
    fontSize: 14,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
  ),
),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_imageFile!,
                                  height: 120, fit: BoxFit.cover),
                            )
                          : Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Center(
                                child: Text(
                                  "Belum ada foto yang dipilih",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo, color: Colors.white),
                        label: const Text(
                          "Upload Bukti Transfer",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          paymentStatus == "PAID" ? null : createDonation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: paymentStatus == "PAID"
                            ? Colors.green
                            : Colors.yellow,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        paymentStatus == "PAID" ? "PAID ✓" : "Pay",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
