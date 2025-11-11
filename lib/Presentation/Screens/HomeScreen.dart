import 'package:finmate/Presentation/widgets/CommonScaffold.dart';
import 'package:flutter/material.dart';

import '../../Constants/String_Constant.dart';
import '../widgets/CustomNavBar.dart';
import 'Dashbaord.dart';
import 'History.dart';
import 'Login_Screen.dart';
import 'Profile.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Widget> Screens = [
    DashboardScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[index],
      bottomNavigationBar: BottomNavBar(
        onTap: (val) {
          setState(() {
            index = val;
          });
        },
      ),
    );
  }
}
