



import 'package:flutter/cupertino.dart';

// BuildContext? context;


sH(double value,BuildContext context) {
  double screenHeight=MediaQuery.of(context).size.height;
  double iniH = 0;
  if (screenHeight < 750) {
    iniH = 844;
  } else {
    iniH = 768;
  }

  return screenHeight * (value / iniH);
}

// sW(double value) {
//   double iniW = Get.width;
//   if (Get.width < 750) {
//     iniW = 390;
//   } else {
//     iniW = 1366;
//   }
//   return Get.width * (value / iniW);
// }