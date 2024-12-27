import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationParent extends StatefulWidget {
  const NotificationParent({super.key});

  @override
  State<NotificationParent> createState() => _NotificationParentState();
}

class _NotificationParentState extends State<NotificationParent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No requests found.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              final activity = data['activity'] ?? "";
              final amount = data['amount'] ?? 0;
              final childName = data['childName'] ?? "Unknown";

              return ListTile(
                title: Text('$childName requested approval'),
                subtitle: Text('Activity: $activity\nAmount: $amount'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('transactions')
                            .add({
                          'type': 'Pengeluaran',
                          'category': 'Request',
                          'amount': amount,
                          'note': activity,
                          'date': DateTime.now().toIso8601String(),
                        });

                        await FirebaseFirestore.instance
                            .collection('requests')
                            .doc(requests[index].id)
                            .delete();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('requests')
                            .doc(requests[index].id)
                            .delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
