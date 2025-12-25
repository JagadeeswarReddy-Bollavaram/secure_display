import 'package:flutter/material.dart';
import 'package:secure_display/secure_display.dart';
import 'home/views/home_page.dart';

/// Example app demonstrating secure_display package usage
/// 
/// This package provides three ways to protect screens from screenshots and recording:
/// 
/// 1. SecureScreenWidget (Recommended - Easiest):
/// ```dart
/// SecureScreenWidget(
///   child: YourWidget(),
/// )
/// ```
/// 
/// 2. SecureScreen class (Manual control):
/// ```dart
/// final secureScreen = SecureScreen();
/// await secureScreen.activate();
/// // ... later
/// await secureScreen.dispose();
/// ```
/// 
/// 3. SecureScreenController (For GetX):
/// ```dart
/// Get.put(SecureScreenController());
/// // Automatically manages lifecycle
/// ```
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Protector Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
