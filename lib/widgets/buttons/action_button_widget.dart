import 'package:flutter/material.dart';

import '../../constants/exports.dart';

class ActionButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final bool isNotify;

  const ActionButtonWidget({
    Key? key,
    required this.onTap,
    required this.iconPath,
    this.isNotify = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.whiteColor.withOpacity(0.1),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
              ),
            ),
          ),
          isNotify == true ? Positioned(
            top: 2,
            right: 3,
            child: Container(
              height: 8.0,
              width: 8.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.redDarkColor,
              ),
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }
}
