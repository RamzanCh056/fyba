
import 'package:flutter/cupertino.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'exports.dart';

BoxDecoration middleBoxDecoration(context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: AppColors.mainDarkColor,
    border: GradientBoxBorder(
      gradient: LinearGradient(
        colors: [
          AppColors.skyBorderColor,
          AppColors.skyBorderColor,
          AppColors.skyBorderColor,
          AppColors.skyBorderColor,
          AppColors.skyBorderColor.withOpacity(0.1),
          AppColors.skyBorderColor.withOpacity(0.1),
          AppColors.skyBorderColor.withOpacity(0.0),
        ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ),
      width: 2.0,
    ),
  );
}

BoxDecoration leftSideBoxDecoration(context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: AppColors.mainDarkColor,
    border: GradientBoxBorder(
      gradient: LinearGradient(
        colors: [
          AppColors.pinkBorderColor,
          AppColors.pinkBorderColor,
          AppColors.pinkBorderColor,
          AppColors.pinkBorderColor,
          AppColors.pinkBorderColor,
          AppColors.pinkBorderColor
              .withOpacity(0.1),
          AppColors.pinkBorderColor
              .withOpacity(0.0),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
      width: 2.0,
    ),
  );
}
BoxDecoration ImagePageBoxDecoration(context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: AppColors.mainDarkColor,
    border: GradientBoxBorder(
      gradient: LinearGradient(
        colors: [
          Color(0xffF48B19),
          Color(0xffF48B19),
         Color(0xffF48B19),
         Color(0xffF48B19),
          Color(0xffF48B19),
          Color(0xffF48B19)
              .withOpacity(0.1),
          Color(0xffF48B19)
              .withOpacity(0.0),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
      width: 2.0,
    ),
  );
}

BoxDecoration threeBoxDecoration(context, {bool isBorder = true}) {
  return BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        AppColors.expandBoxColor,
        AppColors.expandBoxColor,
        AppColors.expandBoxDarkColor,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(10.0),
    border: isBorder == true ? GradientBoxBorder(
      gradient: LinearGradient(
        colors: [
          AppColors.skyBorderColor,
          AppColors.skyBorderColor.withOpacity(0.2),
          AppColors.skyBorderColor.withOpacity(0.0),
          AppColors.skyBorderColor.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      width: 2.0,
    ) : null,
  );
}