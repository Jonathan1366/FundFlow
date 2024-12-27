import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_fam_jo/child_dashboard.dart';
import 'package:wallet_fam_jo/firebase_options.dart';
import 'package:wallet_fam_jo/main_parent_menu.dart';
import 'package:wallet_fam_jo/role_page2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const WalletFamJo());
}

class WalletFamJo extends StatelessWidget {
  const WalletFamJo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'role-page',
      getPages: [
        GetPage(name: '/role-page', page: () => const RolePage2()),
        GetPage(name: '/main-parent-menu', page: () => const MainParentMenu()),
        GetPage(name: '/child-dashboard', page: () => const ChildDashboard()),
      ],
    );
  }
}
