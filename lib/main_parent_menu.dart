import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wallet_fam_jo/parent_dashboard2.dart';
import 'package:wallet_fam_jo/transaction_parent.dart';

class MainParentMenu extends StatefulWidget {
  const MainParentMenu({super.key});

  @override
  State<MainParentMenu> createState() => _MainParentMenuState();
}

class _MainParentMenuState extends State<MainParentMenu> {
  int currentIndex = 0;
  final List<Widget> _page = [
    ParentDashboard(),
    TransactionParent(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _page[currentIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              height: 60,
              indicatorColor: Colors.transparent,
              labelTextStyle:
                  WidgetStateProperty.resolveWith<TextStyle>((state) {
                if (state.contains(WidgetState.selected)) {
                  return const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color.fromARGB(255, 52, 79, 255));
                }
                return const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                    color: Colors.grey);
              })),
          child: NavigationBar(
            animationDuration: Duration(milliseconds: 500),
            backgroundColor: Colors.white,
            destinations: [
              NavigationDestination(
                  icon: const Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                  icon: const Icon(Icons.account_balance_wallet),
                  label: 'Transactions'),
            ],
            selectedIndex: currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
        ));
  }
}
