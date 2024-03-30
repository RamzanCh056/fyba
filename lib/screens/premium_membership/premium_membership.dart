




import 'package:app/constants/app_colors.dart';
import 'package:app/constants/app_sizes.dart';
import 'package:app/screens/auth%20screens/user_signup_screen.dart';
import 'package:app/widgets/resuable_text.dart';
import 'package:flutter/cupertino.dart';

class PremiumMembershipScreen extends StatelessWidget {
  const PremiumMembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsiveHeight(590, context),
      width: responsiveHeight(1043, context),
      padding:EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.mainDarkColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.pinkBorderColor,
          width: 2
        )
      ),
      child: Row(
        children: [
          SizedBox(
            width: responsiveWidth(330, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ReusableText(text: "Get Premium",fontSize:32,fontWeight:FontWeight.w700, color:AppColors.whiteColor),
                const Expanded(
                  child: ReusableText(text: "Aperiam minima amet reprehenderit eaque at ab vero. Suscipit inventore neque occaecati. Quo quia quidem aut inventore dolorem ut velit architecto sit. Magni ducimus et recusandae.",
                  color: AppColors.whiteColor,fontWeight: FontWeight.w400,fontSize: 18,),
                ),
                Container(
                  height: responsiveHeight(61, context),
                  width: responsiveWidth(355, context),
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.premiumButtonBgColor,
                    borderRadius: BorderRadius.circular(26)
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height:responsiveHeight(69, context),
                        width: responsiveWidth(173, context),
                        decoration: BoxDecoration(
                          color: AppColors.premiumButtonColor,
                          borderRadius: BorderRadius.circular(26)
                        ),
                        child: const ReusableText(text: "Yearly",fontSize: 18,fontWeight: FontWeight.w600,),
                      ),
                      Container(
                        height:responsiveHeight(47, context),
                        width: responsiveWidth(173, context),
                        decoration: const BoxDecoration(
                          color: AppColors.premiumButtonColor,
                        ),
                        child:const ReusableText(text: "Monthly",fontSize: 18,fontWeight: FontWeight.w600,),

                      )
                    ],
                  ),
                )
              ],
            ),
          ),


        ],
      ),

    );
  }
}


