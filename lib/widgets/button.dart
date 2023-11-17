import 'package:monkey_chat/constants/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final bool isLoading;

  const Button({super.key, this.onTap, required this.text, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: isLoading
              ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 24.0, // Set the desired width
                    height: 24.0, // Set the desired height
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0, // Adjust the thickness of the indicator's stroke
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Loading...',
                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ])
              : Text(
                  text,
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 16),
                ),
        ),
      ),
    );
  }
}
