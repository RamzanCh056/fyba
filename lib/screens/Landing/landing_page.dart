// import 'package:flutter/material.dart';
// import '/constants/app_colors.dart';
// import '/screens/auth%20screens/admin_login.dart';
//
// import '../Api/team_builder_main_screen.dart';
// import '../main_screen.dart';
//
// class LandingPage extends StatefulWidget {
//   const LandingPage({Key? key}) : super(key: key);
//
//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }
//
// class _LandingPageState extends State<LandingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.mainColor,
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//
//           padding: const EdgeInsets.only(top: 50.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   MaterialButton(
//                     color: Colors.black,
//                     minWidth: 300,
//                     height: 55,
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         // MaterialPageRoute(builder: (context)=>ApiDataFromFirebase())
//                         MaterialPageRoute(builder: (context) => MainScreen()),
//                       );
//                     },
//                     shape: RoundedRectangleBorder(
//                       side: const BorderSide(color: Colors.black),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Center(
//                         child: Text(
//                       "User",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     )),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   MaterialButton(
//                     color: Colors.black,
//                     minWidth: 300,
//                     height: 55,
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()),
//                       );
//                     },
//                     shape: RoundedRectangleBorder(
//                       side: const BorderSide(color: Colors.black),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Center(
//                         child: Text(
//                       "Admin",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     )),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
