import 'package:flutter/material.dart';

import '../widgets/CommonScaffold.dart';
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffoldWidget(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('History')],
      ),
      appBarTitle: 'History',
    );;
  }
}
