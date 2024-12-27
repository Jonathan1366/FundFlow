import 'package:flutter/material.dart';
import 'package:wallet_fam_jo/child_login.dart';
import 'package:wallet_fam_jo/parent_login.dart';

class RolePage2 extends StatefulWidget {
  const RolePage2({super.key});

  @override
  State<RolePage2> createState() => _RolePage2State();
}

class _RolePage2State extends State<RolePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Choose Role'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ParentLogin()));
              },
              child: Text('Parent'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ChildLogin()));
              },
              child: Text('Child'),
            ),
          ],
        )));
  }
}
