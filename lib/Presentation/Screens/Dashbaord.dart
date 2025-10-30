import 'package:flutter/material.dart';

import '../widgets/CommonScaffold.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffoldWidget(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Dashboard')],
      ),
      appBarTitle: 'Dashboard',
    );;
  }
}
