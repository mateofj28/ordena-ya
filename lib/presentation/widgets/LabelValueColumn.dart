import 'package:flutter/material.dart';



class LabelValueColumn extends StatelessWidget {
  final String title;
  final String value;
  final Color textColor;
  final double titleSize;
  final double valueSize;

  const LabelValueColumn({
    Key? key,
    required this.title,
    required this.value,
    this.textColor = Colors.black,
    this.titleSize = 16,
    this.valueSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
