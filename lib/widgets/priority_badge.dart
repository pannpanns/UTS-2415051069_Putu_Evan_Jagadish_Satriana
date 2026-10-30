import 'package:flutter/material.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;

  const PriorityBadge({super.key, required this.priority});

  Color get _backgroundColor {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return const Color(0xFFFDECEC);
      case 'sedang':
        return const Color(0xFFFFF4E5);
      case 'rendah':
        return const Color(0xFFE8F6EF);
      default:
        return const Color(0xFFF0F0F5);
    }
  }

  Color get _textColor {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return const Color(0xFFD94C4C);
      case 'sedang':
        return const Color(0xFFD18A24);
      case 'rendah':
        return const Color(0xFF279B72);
      default:
        return const Color(0xFF777787);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: _textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
