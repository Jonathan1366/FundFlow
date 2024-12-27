import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  late TooltipBehavior _tooltipBehavior;
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = "";

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality here
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Transactions',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchKeyword = _searchController.text.trim();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('transactions')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Tidak ada transaksi.'));
                }

                final transactions = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return _searchKeyword.isEmpty ||
                      (data['note'] ?? "")
                          .toLowerCase()
                          .contains(_searchKeyword.toLowerCase());
                }).toList();

                final List<TransactionData> incomeData = [];
                final List<TransactionData> expenseData = [];

                double cumulativeIncome = 0;
                double cumulativeExpense = 0;
                int index = 0;

                for (var doc in transactions) {
                  final data = doc.data() as Map<String, dynamic>;
                  final type = data['type'] ?? "";
                  final amount = (data['amount'] ?? 0).toDouble();

                  if (type == "Pendapatan") {
                    cumulativeIncome += amount;
                    incomeData.add(
                        TransactionData(index.toString(), cumulativeIncome));
                  } else if (type == "Pengeluaran") {
                    cumulativeExpense += amount;
                    expenseData.add(
                        TransactionData(index.toString(), cumulativeExpense));
                  }
                  index++;
                }

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SfCartesianChart(
                        title: const ChartTitle(
                            text: "Cumulative Cash Flow",
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17)),
                        legend: const Legend(isVisible: true),
                        tooltipBehavior: _tooltipBehavior,
                        series: <CartesianSeries>[
                          LineSeries<TransactionData, String>(
                            dataSource: incomeData,
                            xValueMapper: (TransactionData data, _) =>
                                data.index,
                            yValueMapper: (TransactionData data, _) =>
                                data.value,
                            color: Colors.green,
                            name: 'Pendapatan',
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                          ),
                          LineSeries<TransactionData, String>(
                            dataSource: expenseData,
                            xValueMapper: (TransactionData data, _) =>
                                data.index,
                            yValueMapper: (TransactionData data, _) =>
                                data.value,
                            color: Colors.red,
                            name: 'Pengeluaran',
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                          ),
                        ],
                        primaryXAxis: const CategoryAxis(
                          title: AxisTitle(text: 'Transaction Index'),
                        ),
                        primaryYAxis: const NumericAxis(
                          title: AxisTitle(text: 'Cumulative Amount'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final data = transactions[index].data()
                              as Map<String, dynamic>;
                          final note = data['note'] ?? "";
                          final type = data['type'] ?? "";
                          final amount = data['amount'] ?? 0;
                          final date = data['date'] ?? "";

                          return ListTile(
                            leading: Icon(
                              type == "Pendapatan"
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: type == "Pendapatan"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text(note),
                            subtitle: Text(
                                'Type: $type\nAmount: $amount\nDate: $date'),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionData {
  TransactionData(this.index, this.value);
  final String index;
  final double value;
}
