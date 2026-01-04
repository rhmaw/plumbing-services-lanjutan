import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}