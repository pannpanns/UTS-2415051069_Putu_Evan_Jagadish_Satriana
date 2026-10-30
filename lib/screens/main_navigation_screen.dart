import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'task_list_screen.dart';
import 'course_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    TaskListScreen(),
    CourseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),

      body: SafeArea(
        top: true,
        bottom: false,
        left: true,
        right: true,
        child: IndexedStack(index: _selectedIndex, children: _screens),
      ),

      bottomNavigationBar: ColoredBox(
        color: Colors.white,
        child: SafeArea(
          top: false,
          left: true,
          right: true,
          child: NavigationBar(
            height: isLandscape ? 62 : 68,
            backgroundColor: Colors.white,
            elevation: 0,
            indicatorColor: const Color(0xFFE5F3E8),
            selectedIndex: _selectedIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment_rounded),
                label: 'Tugas',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded),
                label: 'Mata Kuliah',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
