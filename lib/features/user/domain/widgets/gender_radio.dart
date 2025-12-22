// TODO Implement this library.
import 'package:flutter/material.dart';

class GenderRadio extends StatelessWidget {
  final String value;
  final String groupValue;
  final Function(String) onChanged;

  const GenderRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        title: Text(value),
        onChanged: (val) => onChanged(val!),
      ),
    );
  }
}
