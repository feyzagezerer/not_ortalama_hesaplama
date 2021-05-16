import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:not_ortalama_hesaplama/average_calculation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
  Admob.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple, accentColor: Colors.green),
      home: AverageCalculation(),
    );
  }
}
