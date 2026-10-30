import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const TuntasKuliahApp());
}

class TuntasKuliahApp extends StatelessWidget {
  const TuntasKuliahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TuntasKuliah',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F8F4),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E8B57)),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
