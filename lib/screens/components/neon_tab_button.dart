import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../constants/exports.dart';

class NeonTabButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Gradient gradient;
  final double btnHeight;
  final double btnWidth;
  final String btnText;
  final Color btnTextColor;

  const NeonTabButtonWidget({
    Key? key,
    this.onTap,
    required this.gradient,
    required this.btnHeight,
    required this.btnWidth,
    required this.btnText,
    this.btnTextColor = AppColors.whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: btnHeight,
        width: btnWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.mainDarkColor,
          border: GradientBoxBorder(
            gradient: gradient,
            width: 2.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                btnText,
                style: poppinsRegular.copyWith(
                  fontSize: 12,
                  color: btnTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
