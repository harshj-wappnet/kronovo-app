import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color white = Colors.white;
const Color primarygreen = Color(0xFF31A339);
const Color darkgreen = Color(0xFF227027);
const Color lightgreen = Color(0xFF49F054);
const Color bluishGreen = Color(0xFF90F096);

class Theme{

  static final theme = ThemeData(
    primaryColor: primarygreen,
    brightness: Brightness.light,
  );

}
TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
  textStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
      color: Colors.grey
  )
  );
}

TextStyle get subHeadingStyleblack{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
      )
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
      )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black));
}

TextStyle get subtitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[600]));
}