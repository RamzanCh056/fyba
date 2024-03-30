import 'package:flutter/cupertino.dart';

double height(context) {
  return MediaQuery.of(context).size.height;
}

double width(context) {
  return MediaQuery.of(context).size.width;
}


responsiveHeight(double value,BuildContext context) {
  double iniH = MediaQuery.of(context).size.height;
  if (iniH < 750) {
    iniH = 844;
  } else {
    iniH = 768;
  }

  return MediaQuery.of(context).size.height * (value / iniH);
}

responsiveWidth(double value,BuildContext context) {
  double iniW = MediaQuery.of(context).size.width;
  if (iniW < 750) {
    iniW = 390;
  } else {
    iniW = 1366;
  }
  return MediaQuery.of(context).size.width * (value / iniW);
}

Widget sizedBoxH5=const SizedBox(height: 5,);
Widget sizedBoxH10=const SizedBox(height: 10,);
Widget sizedBoxH15=const SizedBox(height: 15,);
Widget sizedBoxH20=const SizedBox(height: 20,);
Widget sizedBoxH30=const SizedBox(height: 30,);

Widget sizedBoxW5=const SizedBox(width: 5,);
Widget sizedBoxW10=const SizedBox(width: 10,);
Widget sizedBoxW15=const SizedBox(width: 15,);
Widget sizedBoxW20=const SizedBox(width: 20,);
Widget sizedBoxW30=const SizedBox(width: 30,);