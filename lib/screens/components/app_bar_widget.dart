import 'dart:convert';

import 'package:app/providers/basic_provider.dart';
import 'package:app/screens/privacy_policy/privacy_policy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Admin/admin_homescreen.dart';
import '../privacy_policy/terms_and_conditions.dart';
import '/screens/Api/get_image_data.dart';
import '/widgets/responsive_widget.dart';

import '../../constants/exports.dart';
import '../../widgets/buttons/action_button_widget.dart';
import '../../widgets/buttons/login_button.dart';
import '../auth screens/login_screen.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({required this.onPremiumButtonPressed,required this.isSubscribed,required this.isAdmin,Key? key}) : super(key: key);
  final VoidCallback onPremiumButtonPressed;
  final bool isSubscribed;
  final bool isAdmin;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      padding: ResponsiveWidget.isWebScreen(context)
          ? const EdgeInsets.symmetric(vertical: 16, horizontal: 20)
          : const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.whiteColor.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: ResponsiveWidget.isWebScreen(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// menu icon
                IconButton(
                  onPressed: () {},
                  icon: const MenuIcon(),
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/privacy');
                    },
                    child: Text("Privacy",style: TextStyle(color: AppColors.whiteColor),)),
                SizedBox(width: 10,),
                TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/terms');
                    },
                    child: Text("Terms",style: TextStyle(color: AppColors.whiteColor),)),
                SizedBox(width: 10,),
                !widget.isAdmin?const SizedBox.shrink():TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminHomeScreen()));
                    },
                    child: const Text("Admin View",style: TextStyle(color: AppColors.whiteColor),)),

                SizedBox(width: height(context) * 0.03),

                /// premium button
                PremiumButton(onTap: widget.onPremiumButtonPressed,isSubscribed: widget.isSubscribed,),

                const Spacer(),

                /// actions icons
                // ActionButtonWidget(onTap: () {}, iconPath: AppIcons.chat),
                // const SizedBox(width: 16),
                // ActionButtonWidget(
                //     onTap: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (context) => ApiData()));
                //     },
                //     iconPath: AppIcons.setting),
                // const SizedBox(width: 16),
                // ActionButtonWidget(
                //   onTap: () {},
                //   iconPath: AppIcons.bell,
                //   isNotify: true,
                // ),
                // const SizedBox(width: 50),


                ///
                /// 16-May-2023
                /// Requirement # 2a
                /// Log In Button
                ///
                ///
                FirebaseAuth.instance.currentUser!=null?LoginButton(onTap: () async{
                  await FirebaseAuth.instance.signOut().then((value)async{
                    SharedPreferences instance=await SharedPreferences.getInstance();
                    await instance.clear();

                    Fluttertoast.showToast(msg: "Logged out successfully");
                    Navigator.pushReplacementNamed(context, "/");
                    setState(() {

                    });
                  });

                },
                  buttonTitle: "Logout",):LoginButton(onTap: ()async{
                  Navigator.pushNamed(context, "/signin");
                },buttonTitle: "Login",),
                /// user name and image
                // Text(
                //   'Madeline Goldner',
                //   style: poppinsRegular.copyWith(
                //     fontSize: 16,
                //     color: AppColors.whiteColor,
                //   ),
                // ),
                // const SizedBox(width: 10),
                // const CircleAvatar(
                //   radius: 25,
                //   backgroundImage: AssetImage(AppImages.userImage),
                // ),
                const SizedBox(width: 8.0),
                // IconButton(
                //   onPressed: () {},
                //   icon: SvgPicture.asset(AppIcons.dotVert),
                // ),
              ],
            )
          : ResponsiveWidget.isTabletScreen(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// menu icon
                    IconButton(
                      onPressed: () {},
                      icon: const MenuIcon(),
                    ),
                    SizedBox(width: height(context) * 0.016),
                    TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/privacy');
                        },
                        child: Text("Privacy",style: TextStyle(color: AppColors.whiteColor),)),
                    SizedBox(width: 10,),
                    TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, "/terms");
                        },
                        child: Text("Terms",style: TextStyle(color: AppColors.whiteColor),)),
                    SizedBox(width: 10,),
                    !widget.isAdmin?SizedBox.shrink():TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminHomeScreen()));
                        },
                        child: const Text("Admin View",style: TextStyle(color: AppColors.whiteColor),)),
                    SizedBox(width: height(context) * 0.03),

                    /// premium button
                    PremiumButton(onTap: widget.onPremiumButtonPressed,isSubscribed: widget.isSubscribed,),

                    const Spacer(),

                    /// actions icons
                    // ActionButtonWidget(onTap: () {}, iconPath: AppIcons.chat),
                    // const SizedBox(width: 8),
                    // ActionButtonWidget(
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => ApiData()));
                    //     },
                    //     iconPath: AppIcons.setting),
                    // const SizedBox(width: 8),
                    // ActionButtonWidget(
                    //   onTap: () {},
                    //   iconPath: AppIcons.bell,
                    //   isNotify: true,
                    // ),
                    // const SizedBox(width: 20),
                    //
                    // /// user name and image
                    // Text(
                    //   'Madeline Goldner',
                    //   style: poppinsRegular.copyWith(
                    //     fontSize: 12,
                    //     color: AppColors.whiteColor,
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    // const CircleAvatar(
                    //   radius: 22,
                    //   backgroundImage: AssetImage(AppImages.userImage),
                    // ),
                    // const SizedBox(width: 8.0),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: SvgPicture.asset(AppIcons.dotVert),
                    // ),

                    FirebaseAuth.instance.currentUser!=null?LoginButton(onTap: () async{
                      await FirebaseAuth.instance.signOut().then((value)async{
                        Fluttertoast.showToast(msg: "Logged out successfully");
                        SharedPreferences instance=await SharedPreferences.getInstance();
                        await instance.clear();
                        Navigator.pushReplacementNamed(context, "/");
                        setState(() {

                        });
                      });

                    },
                      buttonTitle: "Logout",):LoginButton(onTap: ()async{
                      Navigator.pushNamed(context, "/signin");
                    },buttonTitle: "Login",),
                  ],
                )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// menu icon
                  IconButton(
                    onPressed: () {},
                    icon: const MenuIcon(),
                  ),
                  const SizedBox(width: 12.0),
                  SizedBox(width: 10,),
                  !widget.isAdmin?SizedBox.shrink():TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminHomeScreen()));
                      },
                      child: const Text("Admin View",style: TextStyle(color: AppColors.whiteColor),)),

                  /// premium button
                  PremiumButton(onTap: widget.onPremiumButtonPressed,isSubscribed:widget.isSubscribed),

                  const Spacer(),

                  /// actions icons
                  // ActionButtonWidget(onTap: () {}, iconPath: AppIcons.chat),
                  // const SizedBox(width: 8),
                  // ActionButtonWidget(
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ApiData()));
                  //     },
                  //     iconPath: AppIcons.setting),
                  // const SizedBox(width: 8),
                  // ActionButtonWidget(
                  //   onTap: () {},
                  //   iconPath: AppIcons.bell,
                  //   isNotify: true,
                  // ),

                  /// user name and image
                  // Text('Madeline Goldner',
                  //   style: poppinsRegular.copyWith(
                  //     fontSize: 16,
                  //     color: AppColors.whiteColor,
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  // const CircleAvatar(
                  //   radius: 22,
                  //   backgroundImage: AssetImage(AppImages.userImage),
                  // ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: SvgPicture.asset(AppIcons.dotVert),
                  // ),
                  FirebaseAuth.instance.currentUser!=null?LoginButton(onTap: () async{
                    await FirebaseAuth.instance.signOut().then((value)async{
                      SharedPreferences instance=await SharedPreferences.getInstance();
                      await instance.clear();
                      Fluttertoast.showToast(msg: "Logged out successfully");
                      Navigator.pushReplacementNamed(context, "/");
                      setState(() {

                      });
                    });

                  },
                    buttonTitle: "Logout",):LoginButton(onTap: ()async{
                    Navigator.pushNamed(context, "/signin");
                  },buttonTitle: "Login",),
                ],
              ),
    );
  }
}
