// TODO Implement this library.
import 'package:flutter/material.dart';

class SkillCheckbox extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const SkillCheckbox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: CheckboxListTile(
        value: value,
        title: Text(title),
        onChanged: (val) => onChanged(val!),
      ),
    );
  }
}
