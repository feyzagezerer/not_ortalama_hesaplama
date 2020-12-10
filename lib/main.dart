import 'package:flutter/material.dart';
import 'package:not_ortalama_hesaplama/ortalama_hesaplama.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan, accentColor: Colors.green),
      home: OrtalamaHesaplama(),
    );
  }
}
