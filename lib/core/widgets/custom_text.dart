import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    required this.size,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.white,
    this.textAlign,
    this.onTap,
  });
  final String text;
  final double size;
  final VoidCallback? onTap;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign,
        softWrap: true,
        style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
