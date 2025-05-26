// custom_autocomplete.dart
import 'package:flutter/material.dart';

class CustomAutocomplete extends StatelessWidget {
  final List<String> options;
  final String label;
  final String initialValue;
  final void Function(String) onSelected;

  const CustomAutocomplete({
    super.key,
    required this.options,
    required this.onSelected,
    this.label = 'Buscar cliente',
    this.initialValue = '',
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') return const Iterable<String>.empty();
        return options.where((String option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onEditingComplete: onEditingComplete,
        );
      },
    );
  }
}
