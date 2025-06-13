import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tubes/model/HistoryItem.dart';


import 'dart:convert';

class Historypage extends StatefulWidget {
  const Historypage({super.key});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  List<HistoryItem> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/api/history'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      setState(() {
        history = items.map((e) => HistoryItem.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
          automaticallyImplyLeading: false, // <-- tambahkan ini

      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? const Center(child: Text('No history found'))
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return NotificationItem(
                      icon: Icons.attach_money_outlined,
                      title: item.campaignName,
                      subtitle: item.donationTime,
                      amount: 'Rp. ${item.totalDonated.toStringAsFixed(0)}',
                    );
                  },
                ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.yellow,
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        amount,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }
}