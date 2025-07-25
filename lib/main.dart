import 'package:flutter/material.dart';
import 'screens/connect_screen.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send to Phone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ConnectScreen(), 
    );
  }
}
