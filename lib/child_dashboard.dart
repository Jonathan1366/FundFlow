import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildDashboard extends StatefulWidget {
  const ChildDashboard({super.key});

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Dashboard'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('requests').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Tidak ada kegiatan.'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final data = requests[index].data() as Map<String, dynamic>;
                    final activity = data['activity'] ?? "";
                    final amount = data['amount'] ?? 0;
                    final type = data['type'] ?? "";
                    final timestamp = (data['timestamp'] as Timestamp?)
                            ?.toDate()
                            .toString() ??
                        "";

                    return ListTile(
                      leading: Icon(
                        type == "Pendapatan"
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: type == "Pendapatan" ? Colors.green : Colors.red,
                      ),
                      title: Text(activity),
                      subtitle:
                          Text('Nominal: Rp $amount\nTanggal: $timestamp'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
