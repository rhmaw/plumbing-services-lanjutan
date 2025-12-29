// TODO Implement this library.
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        obscureText: isPassword,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }
}
