import 'package:flutter/material.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  // List of notifications
  List<Map<String, String>> notifications = [
    {
      'icon': 'phone',
      'title': 'Donate to Isha Foundation',
      'subtitle': '08 Nov 2023 • 9:40 PM',
      'amount': 'Rp. 50.000'
    },
    {
      'icon': 'phone',
      'title': 'Donate to Isha Foundation',
      'subtitle': '06 Nov 2023 • 2:09 PM',
      'amount': 'Rp. 75.000'
    },
    {
      'icon': 'phone',
      'title': 'Donate to Isha Foundation',
      'subtitle': '04 Nov 2023 • 1:09 PM',
      'amount': 'Rp. 150.000'
    },
    {
      'icon': 'phone',
      'title': 'Donate to Isha Foundation',
      'subtitle': '01 Nov 2023 • 12:09 PM',
      'amount': 'Rp. 50.000'
    },
    {
      'icon': 'fastfood',
      'title': 'Donate to Isha Foundation',
      'subtitle': '01 Nov 2023 • 12:09 PM',
      'amount': '5 Kg'
    },
    {
      'icon': 'fastfood',
      'title': 'Donate to Isha Foundation',
      'subtitle': '01 Nov 2023 • 12:09 PM',
      'amount': '1 Kg'
    },
  ];

  // Function to clear all notifications
  void clearAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text('No notifications available.'))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      var notification = notifications[index];
                      return NotificationItem(
                        icon: notification['icon'] == 'phone'
                            ? Icons.attach_money_outlined
                            : Icons.fastfood,
                        title: notification['title']!,
                        subtitle: notification['subtitle']!,
                        amount: notification['amount']!,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: clearAllNotifications,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(100, 50),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
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
