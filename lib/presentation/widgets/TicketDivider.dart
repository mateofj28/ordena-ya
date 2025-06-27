




import 'package:flutter/material.dart';

class TicketDivider extends StatelessWidget {
  const TicketDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '– – – – – – – – – – – – –',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }
}
