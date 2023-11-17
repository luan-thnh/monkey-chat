import 'package:flutter/material.dart';
import 'package:monkey_chat/constants/colors.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final double? paddingHorizontal, borderRadius;

  const Input(
      {super.key,
      required this.controller,
      required this.hintText,
      this.prefixIcon,
      required this.obscureText,
      this.paddingHorizontal = 0,
      this.borderRadius = 16});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: paddingHorizontal!),
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.grey), borderRadius: BorderRadius.circular(borderRadius!)),
          focusedBorder:
              OutlineInputBorder(borderSide: const BorderSide(width: 2, color: AppColors.black), borderRadius: BorderRadius.circular(borderRadius!)),
          fillColor: AppColors.black,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.grey),
        ));
  }
}
