import 'package:flutter/material.dart';

const Color white = Colors.white;
const Color primarygreen = Color(0xFF31A339);
const Color darkgreen = Color(0xFF227027);
const Color lightgreen = Color(0xFF49F054);
const Color bluishGreen = Color(0xFF90F096);

class Theme {
  static final theme = ThemeData(
    primaryColor: primarygreen,
    brightness: Brightness.light,
  );
}

TextStyle get subHeadingStyle {
  return TextStyle(
      fontSize: 24,
      fontFamily: 'lato',
      fontWeight: FontWeight.bold,
      color: Colors.grey);
}

TextStyle get subHeadingStyleblack {
  return TextStyle(
    fontSize: 24,
    fontFamily: 'lato',
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

TextStyle get headingStyle {
  return TextStyle(
    fontSize: 32,
    fontFamily: 'lato',
    fontWeight: FontWeight.bold,
  );
}

TextStyle get titleStyle {
  return TextStyle(
      fontSize: 16,
      fontFamily: 'lato',
      fontWeight: FontWeight.w400,
      color: Colors.black);
}

TextStyle get subtitleStyle {
  return TextStyle(
      fontSize: 14,
      fontFamily: 'lato',
      fontWeight: FontWeight.w400,
      color: Colors.grey[600]);
}
