import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionChild extends StatefulWidget {
  const TransactionChild({super.key});

  @override
  State<TransactionChild> createState() => _TransactionChildState();
}

class _TransactionChildState extends State<TransactionChild> {
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedType = "Pendapatan"; // Default value

  void _submitRequest() async {
    final activity = _activityController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    if (activity.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tolong isi semua kolom dengan benar.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('requests').add({
        'activity': activity,
        'amount': amount,
        'type': _selectedType,
        'childName':
            'Child Name', // Replace with dynamic child name if available
        'timestamp': Timestamp.now(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permohonan berhasil dikirim.')),
      );
      _activityController.clear();
      _amountController.clear();
      setState(() {
        _selectedType = "Pendapatan";
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim permohonan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajukan Permohonan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Jenis Transaksi'),
              value: _selectedType,
              items: ["Pendapatan", "Pengeluaran"].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _activityController,
              decoration: InputDecoration(labelText: 'Nama Kegiatan'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nominal Uang'),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _submitRequest,
                child: Text('Kirim'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
