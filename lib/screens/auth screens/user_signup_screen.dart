import 'package:flutter/material.dart';


// ///
// /// 16-May-2023
// /// User Sign Up Functionality Added
// ///
// ///
//
// class UserSignUpScreen extends StatefulWidget {
//   bool isFromBiometricPage;
//
//   UserSignUpScreen({this.isFromBiometricPage = false});
//
//   @override
//   State<UserSignUpScreen> createState() => _UserSignUpScreenState();
// }
//
// class _UserSignUpScreenState extends State<UserSignUpScreen> {
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//
//   bool showPass = true;
//   bool chekPass =true;
//   bool emailAlreadyExists=false;
//
//   userSignUp(BuildContext context) async {
//
//     UserCollectionModel user=UserCollectionModel(
//       userId: DateTime.now().microsecondsSinceEpoch.toString(),
//         userName: userNameController.text,
//         userEmail: emailController.text.toLowerCase(),
//         signinType: "Email/Password",
//         userPassword: passwordController.text);
//
//     var authResult = await FirebaseFirestore.instance
//         .collection(StaticInfo.userCollection)
//         .where(userCollectionFields.userEmail, isEqualTo: emailController.text.toLowerCase())
//         .get();
//
//     print(authResult.docs.isNotEmpty);
//     emailAlreadyExists=authResult.docs.isNotEmpty;
//
//     if(emailAlreadyExists){
//       Fluttertoast.showToast(msg: "Email Already Exists");
//     }else{
//       await FirebaseFirestore.instance.collection
//         (StaticInfo.userCollection).add(user.toJson()).then((value) => {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signed Up Successfully"))),
//         Navigator.push(context, MaterialPageRoute(builder: (context)=>
//         const MainScreen(),
//         ))
//       }).onError((error, stackTrace) => {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed due to $error")))
//       });
//
//     }
//
//
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
//             "User Sign Up",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, ),
//           child: SingleChildScrollView(
//             child: Form(
//               key: formKey,
//               child: Center(
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width*.4,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         height: 50,
//                       ),
//                       const Text(
//                         "Name",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       // Email TextField
//                       ReusableTextForm(
//                         hintText: 'Enter Name',
//                         controller: userNameController,
//                         prefixIcon: Icons.email_outlined,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return 'This field is required';
//                           }
//                         },
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       //email
//                       const Text(
//                         "E-mail",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       // Email TextField
//                       ReusableTextForm(
//                         hintText: 'Enter Email',
//                         controller: emailController,
//                         prefixIcon: Icons.email_outlined,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return 'This field is required';
//                           }else if(v.contains('@') && v.endsWith('.com')){
//                             return null;
//                           }else{
//                             return 'Enter Valid Email';
//                           }
//                         },
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       //password
//                       const Text(
//                         "Password",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       // password TextField
//                       ReusableTextForm(
//                         hintText: 'Enter Password',
//                         controller: passwordController,
//                         obscureText: showPass,
//                         prefixIcon: Icons.lock_outline,
//                         suffixIcon: IconButton(
//                             onPressed: (){
//                               setState(() {
//                                 showPass=!showPass;
//                               });
//                             },
//                             icon: showPass?const Icon(Icons.visibility_off):
//                             const Icon(Icons.visibility)
//                             , color: Colors.white),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return 'This field is required';
//                           }else if(v.length<8){
//                             return 'Password Must Be Atleast 8 Characters';
//                           }
//                         },
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       //password
//                       const Text(
//                         "Confirm Password",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       // password TextField
//                       ReusableTextForm(
//                         hintText: 'Re-Enter Password',
//                         controller: confirmPasswordController,
//                         obscureText: chekPass,
//                         prefixIcon: Icons.lock_outline,
//                         suffixIcon: IconButton(
//                             onPressed: (){
//                               setState(() {
//                                 chekPass=!chekPass;
//                               });
//                             },
//                             icon: chekPass?const Icon(Icons.visibility_off):
//                             const Icon(Icons.visibility)
//                             , color: Colors.white),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (v) {
//                           if (v == null || v.isEmpty) {
//                             return 'This field is required';
//                           }else if(v != passwordController.text){
//                             return 'Password does not match';
//                           }
//                         },
//                       ),
//
//                       const SizedBox(
//                         height: 22,
//                       ),
//                       buttonWidget(),
//                       const SizedBox(
//                         height: 22,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "Already have account",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white),
//                           ),
//                           TextButton(onPressed: (){
//                             Navigator.push(
//                                 context,
//                                 // MaterialPageRoute(builder: (context) => AdminPage()),
//                                 MaterialPageRoute(builder: (context)=> LoginScreen())
//                             );
//                           },
//                               child: const Text("Sign In Here"))
//                         ],
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
//
//   Widget buttonWidget() {
//     return ButtonTheme(
//       height: 47,
//       minWidth: MediaQuery.of(context).size.width,
//       child: MaterialButton(
//         color: Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         onPressed: () async {
//           if (formKey.currentState!.validate()) {
//             userSignUp(context);
//           }
//         },
//         child: const Text(
//           'Sign Up',
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
//         ),
//       ),
//     );
//   }
// }

class ReusableTextForm extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool? obscureText;
  final bool? enabled;
  final Widget? suffixIcon;
  final IconData? prefixIcon;

  const ReusableTextForm({
    Key? key,
    this.validator,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          hintColor: Colors.white,
          textTheme: const TextTheme(
              subtitle1: TextStyle(color: Colors.white)),
          colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.white)),
      child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText!,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.white,
            ),
            enabled: enabled!,
            hintText: hintText,
            contentPadding: const EdgeInsets.only(left: 10),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
          ),
          // validations
          validator: validator),
    );
  }
}
