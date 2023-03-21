import 'package:flutter/cupertino.dart';

double hp(double percentage, BuildContext context) {
  double result = (MediaQuery.of(context).size.height * percentage) / 100;
  return result;
}

double wp(double percentage, BuildContext context) {
  double result = (MediaQuery.of(context).size.width * percentage) / 100;
  return result;
}

double heightSnackbar(BuildContext context) {
  double result = MediaQuery.of(context).size.height - 100;
  return result;
}
