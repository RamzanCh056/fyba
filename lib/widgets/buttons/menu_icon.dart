import 'package:flutter/material.dart';
import '/constants/app_colors.dart';

class MenuIcon extends StatelessWidget {
  const MenuIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 8.0,
              width: 8.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: AppColors.whiteColor,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.whiteColor,
                    blurRadius: 11.0,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5.0),
            Container(
              height: 8.0,
              width: 8.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: AppColors.pinkBorderColor,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.pinkBorderColor,
                    blurRadius: 11.0,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 8.0,
              width: 8.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: AppColors.pinkBorderColor,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.pinkBorderColor,
                    blurRadius: 11.0,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5.0),
            Container(
              height: 8.0,
              width: 8.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: AppColors.whiteColor,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.whiteColor,
                    blurRadius: 11.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
