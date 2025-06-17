import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AdjustValue extends StatelessWidget {
  final String label;
  const AdjustValue({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          width: 120,
          height: 50,
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(HugeIcons.strokeRoundedRemove01),
              ),
              Text('10'),
              IconButton(
                onPressed: () {},
                icon: Icon(HugeIcons.strokeRoundedAdd01),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
