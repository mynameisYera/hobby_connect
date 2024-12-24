import 'package:flutter/material.dart';
import 'package:hobby/core/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Widget widget;
  const CustomButtonWidget(
      {super.key, required this.onTap, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: AppColors.mainColor),
              borderRadius: BorderRadius.circular(30)),
          child: Center(child: widget)),
    );
  }
}
