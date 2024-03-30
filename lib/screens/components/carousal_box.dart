import 'package:flutter/material.dart';
import '/constants/exports.dart';
import '/widgets/small_image_widget.dart';

class CarouselBox extends StatelessWidget {
  const CarouselBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      height: 100,
      decoration: threeBoxDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Carousel',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SmallImageWidget(imageUrl:'',isStar: true),
              const SizedBox(width: 8.0),
              SvgPicture.asset(AppIcons.arrowNext),
              const SizedBox(width: 8.0),
              const SmallImageWidget(imageUrl:''),
              const SizedBox(width: 8.0),
              SvgPicture.asset(AppIcons.arrowNext),
              const SizedBox(width: 8.0),
              const SmallImageWidget(imageUrl:''),
            ],
          ),
        ],
      ),
    );
  }
}
