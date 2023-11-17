import 'package:flutter/material.dart';
import 'package:monkey_chat/constants/colors.dart';

void showSnackBar(BuildContext context, String text, bool type) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
      ),
      duration: const Duration(milliseconds: 500),
      backgroundColor: type ? AppColors.success : AppColors.error,
    ),
  );
}
