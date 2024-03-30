import 'package:flutter/material.dart';

import '../../constants/exports.dart';

class SmallButtons extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String btnText;
  final Color btnColor;
  bool isMobile;
  bool isTablet;
  SmallButtons({
    Key? key,
    required this.onTap,
    required this.iconPath,
    required this.btnText,
    required this.btnColor,
    this.isMobile=false,
    this.isTablet=false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: isTablet?40:30,
        width: isMobile?width(context):isTablet?width(context) * 0.2:width(context) * 0.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: btnColor,
          boxShadow: [
            BoxShadow(
              color: btnColor.withOpacity(0.5),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(width: 5.0),
            Text(
              btnText,
              style: poppinsRegular.copyWith(
                fontSize: 14,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
