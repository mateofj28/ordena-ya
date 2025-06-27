import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String inputType; // 'number', 'email', 'text'
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.inputType,
    this.controller,
  });

  TextInputType _getKeyboardType() {
    switch (inputType) {
      case 'number':
        return TextInputType.number;
      case 'email':
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: _getKeyboardType(),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
