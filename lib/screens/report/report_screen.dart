import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  static const routeName = 'report_screen';

  ReportScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ReportScreen(),
    );
  }

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('report Screen'),
      ),
    );
  }
}
