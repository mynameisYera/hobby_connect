import 'package:flutter/material.dart';

class TextStyles {
  //header  text style
  static TextStyle headerText = const TextStyle(
      fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500);
  //simple  text style
  static TextStyle simpleText = const TextStyle(
      fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300);
  // mini text
  static TextStyle miniText = const TextStyle(
      fontSize: 14, color: Color(0xffCFCFCF), fontWeight: FontWeight.normal);
  // bold mini text
  static TextStyle boldMiniText = const TextStyle(
      fontSize: 14, color: Color(0xffCFCFCF), fontWeight: FontWeight.bold);
  // underline text
  static TextStyle underlineText = const TextStyle(
      fontSize: 14,
      color: Color(0xffCFCFCF),
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white);
  // profile tile text
  static TextStyle tileText = const TextStyle(
    fontSize: 12,
    color: Color(0xffABABAB),
    fontWeight: FontWeight.normal,
  );
}
