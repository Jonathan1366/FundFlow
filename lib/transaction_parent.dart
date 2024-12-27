import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallet_fam_jo/add_transaction.dart';
import 'package:wallet_fam_jo/notification_parent.dart';

class TransactionParent extends StatefulWidget {
  const TransactionParent({super.key});

  @override
  State<TransactionParent> createState() => _TransactionParentState();
}

class _TransactionParentState extends State<TransactionParent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Transaksi'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationParent(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('transactions').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada transaksi.'));
          }

          final transactions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final data = transactions[index].data() as Map<String, dynamic>;
              final type = data['type'] ?? "";
              final category = data['category'] ?? "";
              final amount = data['amount']?.toString() ?? "0";
              final date = data['date'] ?? "";

              return ListTile(
                leading: Icon(
                  type == "Pendapatan"
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: type == "Pendapatan" ? Colors.green : Colors.red,
                ),
                title: Text('$type - $category'),
                subtitle: Text('Jumlah: Rp $amount\nTanggal: $date'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('transactions')
                        .doc(transactions[index].id)
                        .delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 120,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Tambah Transaksi'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTransactionPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
