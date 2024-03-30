
import 'package:app/model/user_model.dart';
import 'package:app/widgets/responsive_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Static/static.dart';
import '../../constants/app_colors.dart';
import '../../services/firestore services/firebase_auth_services/auth_sevices.dart';
import '../Admin/admin_homescreen.dart';
import '../main_screen.dart';
import 'login_screen.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool showPass = true;
  bool chekPass =true;
  bool isLoading=false;


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: ResponsiveWidget.isMobileScreen(context)?EdgeInsets.symmetric(horizontal: 10):const EdgeInsets.symmetric(horizontal: 80),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.fill,
          ),
          color: Colors.black.withOpacity(0.800000011920929),
        ),
        child: SingleChildScrollView(
          child: ResponsiveWidget.isMobileScreen(context)||ResponsiveWidget.isTabletScreen(context)?
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              SizedBox(
                width: ResponsiveWidget.isTabletScreen(context)?MediaQuery.of(context).size.width*.7:MediaQuery.of(context).size.width*.9,

                child: Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        SizedBox(height: height*.1,),
                        RichText(
                            text: const TextSpan(
                                children: [
                                  TextSpan(text: "Signup to",
                                      style: TextStyle(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      )
                                  ),
                                  TextSpan(text: " FYBA",
                                      style: TextStyle(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      )
                                  )
                                ]
                            )
                        ),
                        const SizedBox(height: 10,),
                        const Text("Please fill registration form",
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14
                            )
                        ),
                        const SizedBox(height: 40,),
                        const Text("Name",
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14
                            )
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: userNameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              filled: true,
                              fillColor: Colors.grey
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        const Text("Email Address",
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14
                            )
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              filled: true,
                              fillColor: Colors.grey
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        const Text("Password",
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14
                            )
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: passwordController,
                          obscureText: showPass,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: ()=>setState(() {showPass=!showPass;}),
                                  child: showPass?const Icon(Icons.visibility):const Icon(Icons.visibility_off)),
                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              filled: true,
                              fillColor: Colors.grey
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        const Text("Confirm Password",
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14
                            )
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: showPass,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              filled: true,
                              fillColor: Colors.grey
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'This field is required';
                            }else  if(confirmPasswordController.text != passwordController.text){
                              return 'Password does not match';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 50,),
                        Center(
                          child: InkWell(
                            onTap:()async{

                              if(formKey.currentState!.validate()){
                                UserModel user =UserModel(
                                    userId: "",
                                    userName: userNameController.text,
                                    userEmail: emailController.text,
                                    userPassword: passwordController.text,
                                    signinType: "email"
                                );
                                setState(() {
                                  isLoading=true;
                                });
                                await FirebaseAuthServices().signUp(user, context);
                                setState(() {
                                  isLoading=false;
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: width*.28,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: isLoading?const Center(child: CircularProgressIndicator()):const Text("Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  )
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: width*.13,
                                child: const Divider(color: Colors.white,indent: 10,endIndent: 10,thickness: 1,)),
                            const Text("Or",
                                style: TextStyle(
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )
                            ),
                            SizedBox(
                                width: width*.13,
                                child: const Divider(color: Colors.white,indent: 10,endIndent: 10,thickness: 1,)),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Center(
                          child: InkWell(
                            onTap: ()async{
                              if(kIsWeb){

                                User? user=await FirebaseAuthServices().signInWithGoogleWeb();
                                if (user != null) {
                                  UserModel userData=UserModel(
                                      userId: user.uid,
                                      userName: user.displayName!,
                                      userEmail: user.email!,
                                      userPassword: "Not Applicable",
                                      signinType: "Google Signin");
                                  await FirebaseFirestore.instance.collection(StaticInfo.userCollection).doc(user.uid).set(userData.toJson());
                                  Navigator.pushNamed(context, "/home");
                                }
                              }else {
                                User? user=await FirebaseAuthServices.signInWithGoogle(context: context);
                                if (user != null) {
                                  UserModel userData=UserModel(
                                      userId: user.uid,
                                      userName: user.displayName!,
                                      userEmail: user.email!,
                                      userPassword: "Not Applicable",
                                      signinType: "Google Signin");
                                  await FirebaseFirestore.instance.collection(StaticInfo.userCollection).doc(user.uid).set(userData.toJson());
                                  Navigator.pushNamed(context, "/home");
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: width*.5,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(FontAwesomeIcons.google,color: AppColors.whiteColor,size: 15,),
                                  SizedBox(width: 5,),
                                  Text("Google",
                                      style: TextStyle(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50,),
                        Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Already have account ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 14
                                  )
                              ),
                              InkWell(
                                onTap: ()=>Navigator.pushNamed(context, "/signin"),
                                child: Text("Click here",
                                    style: TextStyle(
                                        color: Colors.pink[600],
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,)
                      ]
                  ),
                ),
              )

            ],
          ):
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: IconButton(
                      onPressed: ()=>Navigator.pop(context),
                      icon: Icon(Icons.arrow_back,color: Colors.white,),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*.37,
                    height: MediaQuery.of(context).size.height,
                    padding:const EdgeInsets.symmetric(vertical: 89,horizontal:44),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/login.png"),
                        fit: BoxFit.fill,
                      ),

                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*.28,

                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      SizedBox(height: height*.1,),
                      RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(text: "Signup to",
                              style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 20
                              )
                              ),
                              TextSpan(text: " FYBA",
                                  style: TextStyle(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  )
                              )
                            ]
                          )
                      ),
                      const SizedBox(height: 10,),
                      const Text("Please fill registration form",
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 14
                          )
                      ),
                      const SizedBox(height: 40,),
                      const Text("Name",
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 14
                          )
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: userNameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            filled: true,
                            fillColor: Colors.grey
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
                      const Text("Email Address",
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 14
                          )
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            filled: true,
                            fillColor: Colors.grey
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
                      const Text("Password",
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 14
                          )
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: passwordController,
                        obscureText: showPass,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: ()=>setState(() {showPass=!showPass;}),
                              child: showPass?const Icon(Icons.visibility):const Icon(Icons.visibility_off)),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            filled: true,
                            fillColor: Colors.grey
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
                      const Text("Confirm Password",
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 14
                          )
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: showPass,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            filled: true,
                            fillColor: Colors.grey
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'This field is required';
                          }else  if(confirmPasswordController.text != passwordController.text){
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 50,),
                      Center(
                        child: InkWell(
                          onTap:()async{

                            if(formKey.currentState!.validate()){
                              UserModel user =UserModel(
                                  userId: "",
                                  userName: userNameController.text,
                                  userEmail: emailController.text,
                                  userPassword: passwordController.text,
                                  signinType: "email"
                              );
                              setState(() {
                                isLoading=true;
                              });
                              await FirebaseAuthServices().signUp(user, context);
                              setState(() {
                                isLoading=false;
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: width*.28,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: isLoading?const Center(child: CircularProgressIndicator()):const Text("Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 20
                                )
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          SizedBox(
                              width: width*.13,
                              child: const Divider(color: Colors.white,indent: 10,endIndent: 10,thickness: 1,)),
                          const Text("Or",
                              style: TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )
                          ),
                          SizedBox(
                              width: width*.13,
                              child: const Divider(color: Colors.white,indent: 10,endIndent: 10,thickness: 1,)),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: ()async{
                              if(kIsWeb){
                                User? user=await FirebaseAuthServices().signInWithGoogleWeb();
                                if (user != null) {
                                  UserModel userData=UserModel(
                                      userId: user.uid,
                                      userName: user.displayName!,
                                      userEmail: user.email!,
                                      userPassword: "Not Applicable",
                                      signinType: "Google Signin");
                                  await FirebaseFirestore.instance.collection(StaticInfo.userCollection).doc(user.uid).set(userData.toJson());
                                  Navigator.pushNamed(context, "/home");
                                }
                              }else {
                                User? user=await FirebaseAuthServices.signInWithGoogle(context: context);
                                if (user != null) {
                                  UserModel userData=UserModel(
                                      userId: user.uid,
                                      userName: user.displayName!,
                                      userEmail: user.email!,
                                      userPassword: "Not Applicable",
                                      signinType: "Google Signin");
                                  await FirebaseFirestore.instance.collection(StaticInfo.userCollection).doc(user.uid).set(userData.toJson());
                                  Navigator.pushNamed(context, "/home");
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: width*.13,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(FontAwesomeIcons.google,color: AppColors.whiteColor,size: 15,),
                                  SizedBox(width: 5,),
                                  Text("Google",
                                      style: TextStyle(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: width*.13,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(FontAwesomeIcons.facebookF,color: AppColors.whiteColor,size: 15,),
                                SizedBox(width: 5,),
                                Text("Facebook",
                                    style: TextStyle(
                                        color: Colors.white,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50,),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Already have account ",
                                style: TextStyle(
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14
                                )
                            ),
                            InkWell(
                              onTap: ()=>Navigator.pushNamed(context, "/signin"),
                              child: Text("Click here",
                                  style: TextStyle(
                                      color: Colors.pink[600],
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 14
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,)
                    ]
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
