// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String selectedType = "Pendapatan"; // Default tab selected
  String selectedCategory = "";
  String selectedAccount = "";
  double amount = 0;
  String note = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _saveTransaction() async {
    try {
      await FirebaseFirestore.instance.collection('transactions').add({
        'type': selectedType,
        'category': selectedCategory,
        'account': selectedAccount,
        'amount': amount,
        'note': note,
        'date': selectedDate.toIso8601String(),
        'time': selectedTime.format(context),
      });
      // ignore: duplicate_ignore
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi berhasil disimpan!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Pendapatan'),
                  selected: selectedType == "Pendapatan",
                  onSelected: (bool selected) {
                    setState(() {
                      selectedType = "Pendapatan";
                    });
                  },
                ),
                SizedBox(width: 16),
                ChoiceChip(
                  label: Text('Pengeluaran'),
                  selected: selectedType == "Pengeluaran",
                  onSelected: (bool selected) {
                    setState(() {
                      selectedType = "Pengeluaran";
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Kategori'),
              items:
                  ['Makanan', 'Transportasi', 'Belanja'] // Example categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value ?? "";
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Rekening'),
              items: ['Bank A', 'Bank B', 'Dompet'] // Example accounts
                  .map((account) => DropdownMenuItem(
                        value: account,
                        child: Text(account),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedAccount = value ?? "";
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah'),
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Catatan'),
              onChanged: (value) {
                setState(() {
                  note = value;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                      'Tanggal: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                ),
                SizedBox(width: 16),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Waktu: ${selectedTime.format(context)}'),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveTransaction,
              child: Center(
                child: Text('SIMPAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
