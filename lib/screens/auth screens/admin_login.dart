// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '/constants/app_colors.dart';
// import '/screens/Admin/admin_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/screens/auth%20screens/user_signup_screen.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../Static/static.dart';
// import '../../model/user_model.dart';
// import '../../services/firestore services/firebase_auth_services/auth_sevices.dart';
// import '../Admin/admin_homescreen.dart';
// import '../Landing/landing_page.dart';
// import '../main_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   bool isFromBiometricPage;
//
//   LoginScreen({this.isFromBiometricPage = false});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController userEmail = TextEditingController();
//   TextEditingController password = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   bool showPass = true;
//
//   bool isLoading=false;
//
//   userLogin() async {
//
//     bool userNameExists=false;
//     bool passwordExists=false;
//     try {
//       ///
//       /// Here we are checking email in admin collection
//       /// If found than we can match passwords  if matched than
//       /// admin will be navigated to admin screen or Api data to
//       /// firestore screen
//       ///
//       /// If email not found in admin collection than we can check it
//       /// in user collection if found there we can match passwords
//       /// if matched than user will be redirected to user or main screen
//       /// else if does not match incorrect password error will be shown
//       ///
//       ///
//       ///
//       var authResult = await FirebaseFirestore.instance
//           .collection(StaticInfo.admin)
//           .where('email', isEqualTo: userEmail.text)
//           .get();
//
//       userNameExists = authResult.docs.isNotEmpty;
//       if (userNameExists) {
//         var authResult = await FirebaseFirestore.instance
//             .collection(StaticInfo.admin)
//             .where('password', isEqualTo: password.text.toLowerCase())
//             .get();
//         passwordExists = authResult.docs.isNotEmpty;
//         if (passwordExists) {
//
//           Fluttertoast.showToast(msg: 'Successfully logged in');
//           //NavigateToHome
//           Navigator.push(
//             context,
//             // MaterialPageRoute(builder: (context) => AdminPage()),
//             MaterialPageRoute(builder: (context)=>const ApiToFirestoreScreen())
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'Incorrect username or password');
//         }
//       } else {
//         var authResult = await FirebaseFirestore.instance
//             .collection(StaticInfo.userCollection)
//             .where(userCollectionFields.userEmail, isEqualTo: userEmail.text.toLowerCase())
//             .get();
//         userNameExists = authResult.docs.isNotEmpty;
//         print(userNameExists);
//         if (userNameExists) {
//           var passwordResult = await FirebaseFirestore.instance
//               .collection(StaticInfo.userCollection)
//               .where(userCollectionFields.userPassword, isEqualTo: password.text.toLowerCase())
//               .get();
//           passwordExists = passwordResult.docs.isNotEmpty;
//           print(passwordExists);
//           if (passwordExists) {
//
//
//             Fluttertoast.showToast(msg: 'Successfully logged in');
//             //NavigateToHome
//             Navigator.push(
//                 context,
//                 // MaterialPageRoute(builder: (context) => AdminPage()),
//                 MaterialPageRoute(builder: (context)=> const MainScreen())
//             );
//           } else {
//             Fluttertoast.showToast(msg: 'Incorrect username or password');
//           }
//         }
//         // Fluttertoast.showToast(msg: 'Incorrect username or password');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Some error occurred $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: AppColors.mainColor,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           centerTitle: true,
//           title: const Text(
//             "Login",
//             style: TextStyle(color: Colors.white,
//             fontSize: 24,
//               fontWeight: FontWeight.w700
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, ),
//           child: Form(
//             key: formKey,
//             child: Center(
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width*.4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 50,
//                     ),
//                     //email
//                     Text(
//                       "E-mail",
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     // Email TextField
//                     ReusableTextForm(
//                       hintText: 'Enter Email',
//                       controller: userEmail,
//                       prefixIcon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (v) {
//                         if (v == null || v.isEmpty) {
//                           return 'This field is required';
//                         }
//                       },
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     //password
//                     Text(
//                       "Password",
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     // password TextField
//                     ReusableTextForm(
//                       hintText: 'Enter Password',
//                       controller: password,
//                       obscureText: showPass,
//                       prefixIcon: Icons.lock_outline,
//                       suffixIcon: IconButton(
//                           onPressed: (){
//                             setState(() {
//                               showPass=!showPass;
//                             });
//                           },
//                           icon: showPass?const Icon(Icons.visibility_off):
//                           const Icon(Icons.visibility)
//                           , color: Colors.white),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (v) {
//                         if (v == null || v.isEmpty) {
//                           return 'This field is required';
//                         }
//                       },
//                     ),
//
//                     const SizedBox(
//                       height: 22,
//                     ),
//                     isLoading?const SizedBox(height:40,width:40,child:
//                     CircularProgressIndicator()):
//                     buttonWidget(),
//                     const SizedBox(
//                       height: 22,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Not have account",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white),
//                         ),
//                         TextButton(onPressed: (){
//                           Navigator.push(
//                               context,
//                               // MaterialPageRoute(builder: (context) => AdminPage()),
//                               MaterialPageRoute(builder: (context)=> UserSignUpScreen())
//                           );
//                         },
//                             child: const Text("Sign Up Here"))
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 22,
//                     ),
//                     Align(
//                         alignment: Alignment.center,
//                         child: Column(
//                           children: [
//                             const Text("Signin With",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w700),),
//                             const SizedBox(
//                               height: 22,
//                             ),
//                             googleSigninButtonWidget()
//                           ],
//                         )),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
//
//   Widget buttonWidget() {
//
//     return ButtonTheme(
//       height: 47,
//       minWidth: MediaQuery.of(context).size.width,
//       child: MaterialButton(
//         color: Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         onPressed: () async {
//
//           if (formKey.currentState!.validate()) {
//             isLoading =true;
//             setState(() {
//
//             });
//             userLogin();
//             isLoading =false;
//             setState(() {
//
//             });
//           }
//         },
//         child: const Text(
//           'Login',
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
//         ),
//       ),
//     );
//   }
//
//   Widget googleSigninButtonWidget() {
//
//     return InkWell(
//       onTap: ()async{
//         if(kIsWeb){
//           User? user=await FirebaseAuthServices().signInWithGoogleWeb();
//           if (user != null) {
//             UserCollectionModel userData=UserCollectionModel(
//                 userId: user.uid,
//                 userName: user.displayName!,
//                 userEmail: user.email!,
//                 userPassword: "Not Applicable",
//                 signinType: "Google Signin");
//             await FirebaseFirestore.instance.collection(StaticInfo.userCollection).doc(user.uid).set(userData.toJson());
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
//           }
//         }else {
//           User? user=await FirebaseAuthServices.signInWithGoogle(context: context);
//           if (user != null) {
//             UserCollectionModel userData=UserCollectionModel(
//                 userId: user.uid,
//                 userName: user.displayName!,
//                 userEmail: user.email!,
//                 userPassword: "Not Applicable",
//                 signinType: "Google Signin");
//             await FirebaseFirestore.instance.collection(StaticInfo.userCollection).doc(user.uid).set(userData.toJson());
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
//           }
//         }
//         },
//       child: Container(
//         width: 100,
//         height: 30,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const[
//             Text(
//               'Google',
//               style: TextStyle(
//                   color: AppColors.mainColor, fontWeight: FontWeight.bold, fontSize: 15),
//             ),
//             SizedBox(width:10),
//             Icon(FontAwesomeIcons.google,color: AppColors.mainColor,size: 20,)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ReusableTextForm extends StatelessWidget {
//   final String? Function(String?)? validator;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final String? hintText;
//   final bool? obscureText;
//   final bool? enabled;
//   final Widget? suffixIcon;
//   final IconData? prefixIcon;
//
//   const ReusableTextForm({
//     Key? key,
//     this.validator,
//     this.controller,
//     this.keyboardType,
//     this.hintText,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.enabled = true,
//     this.prefixIcon,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData(
//           hintColor: Colors.white,
//           textTheme: const TextTheme(
//               subtitle1: TextStyle(color: Colors.white)),
//           colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.white)),
//       child: TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           obscureText: obscureText!,
//           decoration: InputDecoration(
//             suffixIcon: suffixIcon,
//             prefixIcon: Icon(
//               prefixIcon,
//               color: Colors.white,
//             ),
//             enabled: enabled!,
//             hintText: hintText,
//             contentPadding: const EdgeInsets.only(left: 10),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Colors.white, width: 2)),
//             focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Colors.red, width: 2)),
//             errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Colors.red, width: 2)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Colors.white, width: 2)),
//           ),
//           // validations
//           validator: validator),
//     );
//   }
// }
