
import 'package:flutter/material.dart';
// This imports your custom file where the actual "Dashboard" screen is designed.
import 'package:zikar_e_falah/dashboard_screen.dart';

void main() {
  runApp(const MyApp()); // This line tells Flutter to launch the 'MyApp' widget.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // This hides the small red "Debug" banner in the top-right corner of the screen.
      debugShowCheckedModeBanner: false,
      // 'home' defines which screen the user sees first when the app opens.
      // Here, it points to your DashboardScreen widget.
      home: DashboardScreen(), 
    );
  }
}