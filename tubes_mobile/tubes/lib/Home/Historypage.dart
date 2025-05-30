import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> paymentHistory = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPaymentHistory();
  }

  // Fetch payment history from the API
  Future<void> _fetchPaymentHistory() async {
    try {
      const String BASE_URL =
          "http://127.0.0.1:3000"; // Ganti dengan URL backend Anda
      final response =
          await http.get(Uri.parse('$BASE_URL/api/Account/payment-history'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          paymentHistory = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Empty payment history';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  // Delete payment history from the API
  Future<void> _deletePayment(String paymentId) async {
    try {
      const String BASE_URL =
          "http://127.0.0.1:3000"; // Ganti dengan URL backend Anda
      final response = await http.delete(
          Uri.parse('$BASE_URL/api/Account/payment-history/$paymentId'));

      if (response.statusCode == 200) {
        setState(() {
          paymentHistory.removeWhere((payment) => payment['id'] == paymentId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment history deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error deleting payment history: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color.fromARGB(255, 255, 245, 107),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : paymentHistory.isEmpty
                  ? const Center(child: Text('No payment history available'))
                  : ListView.builder(
                      itemCount: paymentHistory.length,
                      itemBuilder: (context, index) {
                        final payment = paymentHistory[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: Icon(Icons.attach_money_outlined,
                                color: Colors.black),
                          ),
                          title: Text(payment['title']),
                          subtitle:
                              Text('${payment['date']} • ${payment['time']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rp. ${payment['amount']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deletePayment(payment['id']);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
