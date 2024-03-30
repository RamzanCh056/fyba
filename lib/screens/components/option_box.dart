import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/constants/app_colors.dart';
import '/constants/app_icons.dart';
import '/constants/app_sizes.dart';
import '/widgets/small_image_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionsBox extends StatelessWidget {
  const OptionsBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        /// options text
        const SizedBox(height: 16.0),
        Text('Options',
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),

        /// levels
        const SizedBox(height: 10.0),
        Container(
          width: width(context),
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.mainDarkColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// texts
              Text('Level 1:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 20),

              /// images
              const SmallImageWidget(
                imageUrl:'',
                imageWidth: 45,
                imageHeight: 45,
              ),
              const SizedBox(width: 8),
              const SmallImageWidget(
                imageUrl:'',
                imageWidth: 45,
                imageHeight: 45,
              ),
              const SizedBox(width: 8),
              const SmallImageWidget(
                imageUrl:'',
                imageWidth: 45,
                imageHeight: 45,
              ),
            ],
          ),
        ),

        /// images
        const SizedBox(height: 12.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// images box
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  SmallImageWidget(
                    imageUrl:'',
                    imageWidth: 36,
                    imageHeight: 36,
                    boxHeight: 36,
                    boxWidth: 36,
                  ),
                  SizedBox(width: 8.0),
                  SmallImageWidget(
                    imageUrl:'',
                    imageWidth: 36,
                    imageHeight: 36,
                    boxHeight: 36,
                    boxWidth: 36,
                  ),
                  SizedBox(width: 8.0),
                  SmallImageWidget(
                    imageUrl:'',
                    imageWidth: 36,
                    imageHeight: 36,
                    boxHeight: 36,
                    boxWidth: 36,
                  ),
                ],
              ),
            ),

            /// icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SvgPicture.asset(AppIcons.arrowNext, height: 15),
            ),

            /// image
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SmallImageWidget(
                    imageUrl:'',
                    imageWidth: 36,
                    imageHeight: 36,
                    boxHeight: 36,
                    boxWidth: 36,
                  ),
                  SizedBox(width: 8.0),
                  SmallImageWidget(
                    imageUrl:'',
                    imageWidth: 36,
                    imageHeight: 36,
                    boxHeight: 36,
                    boxWidth: 36,
                  ),
                  SizedBox(width: 8.0),
                  SmallImageWidget(
                    imageUrl:'',
                    imageWidth: 36,
                    imageHeight: 36,
                    boxHeight: 36,
                    boxWidth: 36,
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