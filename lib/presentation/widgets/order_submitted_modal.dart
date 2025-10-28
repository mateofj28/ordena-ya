import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'custom_button.dart';

class OrderSubmittedModal extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onConfirm;

  const OrderSubmittedModal({
    super.key,
    required this.icon,
    required this.iconColor,
    this.iconSize = 100,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              HugeIcon(
                icon: icon,
                color: iconColor,
                size: iconSize,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              CustomButton(
                label: buttonLabel,
                baseColor: iconColor,
                textColor: Colors.white,
                onTap: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
