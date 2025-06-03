import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final String label;
  final void Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.label = 'Elige una opción',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue == 'N/A' ? null : selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      hint: Text(selectedValue),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
