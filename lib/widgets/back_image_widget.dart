import 'package:flutter/material.dart';

import '../constants/exports.dart';


class BackImageWidget extends StatelessWidget {
  const BackImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: height(context),
          width: width(context),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.backImage),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
