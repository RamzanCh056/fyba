import 'package:flutter/material.dart';

import '../../constants/exports.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonTitle;
  const LoginButton({Key? key, required this.onTap,required this.buttonTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: height(context) * 0.02, vertical: 7.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.pinkBorderColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.pinkBorderColor.withOpacity(0.5),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Icon(Icons.person_2_rounded,
              color: AppColors.whiteColor,
            ),
            const SizedBox(width: 5.0),
            Text(buttonTitle,
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
