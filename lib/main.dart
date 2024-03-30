/// Project run command : flutter run -d chrome --web-browser-flag "--disable-web-security"
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


import 'dart:io';
import 'package:app/providers/comp_provider.dart';
import 'package:app/providers/subscription_provider.dart';

import 'package:app/providers/user_provider.dart';
import 'package:app/screens/auth%20screens/sign_up.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/screens/privacy_policy/privacy_policy.dart';
import 'package:app/screens/privacy_policy/terms_and_conditions.dart';
import 'package:app/screens/riot_callback_screen.dart';
import 'package:app/stripe_payment/payment_cancelled.dart';
import 'package:app/stripe_payment/payment_successfull.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import './providers/basic_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


import './screens/auth screens/login_screen.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   HttpOverrides.global = new MyHttpOverrides();
  setPathUrlStrategy();
  var prefInstance=await SharedPreferences.getInstance();
  await prefInstance.clear();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCE4ejo_vBIKWbKNyAGeabG4PaDnixhZxU",
          authDomain: "gamehub-984bb.firebaseapp.com",
          projectId: "gamehub-984bb",
          storageBucket: "gamehub-984bb.appspot.com",
          messagingSenderId: "693406391829",
          appId: "1:693406391829:web:7661712261c36f1a95781c",
          measurementId: "G-HFMQB3MLS2"
          // apiKey: "AIzaSyCE4ejo_vBIKWbKNyAGeabG4PaDnixhZxU",
          // authDomain: "gamehub-984bb.firebaseapp.com",
          // databaseURL: "", // **DATABASEURL MUST BE GIVEN.**
          // projectId: "gamehub-984bb",
          // storageBucket: "gamehub-984bb.appspot.com",
          // messagingSenderId: "693406391829",
          // appId: "1:693406391829:web:9a26cad439b111c495781c"),
      )
    );
    // var factory = databaseFactoryWeb;
  } else {
    await Firebase.initializeApp();
  }
  Provider.debugCheckInvalidValueType = null;

  Stripe.publishableKey = "pk_test_51Nn6HPGNqLxAA3gqVQiEmwX7HsD3iFVnhtLsGXk1xZwYKi8ZmBYVWmw5faPxkeyZD7ikEqqgT0suI20G3tqWdfZ200dYy2eO5o";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/stripe/.env");


  if(FirebaseAuth.instance.currentUser==null){
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.clear();

  }

  runApp(

    // ChangeNotifierProvider(
    //   create: (context)=>BasicProvider(),
    // child: MyApp(),
    // )
      MultiProvider(
        providers:[
          ChangeNotifierProvider<UserProvider>(create: (_)=>UserProvider(),),
          ChangeNotifierProvider<BasicProvider>(create: (_)=>BasicProvider(),),
          ChangeNotifierProvider(create: (_)=>CompProvider()),
          ChangeNotifierProvider(create: (_)=>SubscriptionProvider())
        ] ,
        child: MyApp(),
      )
  );
}


class MyApp extends StatefulWidget {
  MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            print('firebase connected');

          }
          return MaterialApp(
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                },
              ),
              debugShowCheckedModeBanner: false,
              title: 'FYBA',
              theme: ThemeData(
                useMaterial3: true,
                primarySwatch: Colors.indigo,
              ),

              initialRoute: '/',
              routes: {
                '/home': (context)=>const MainScreen(),
                '/privacy': (context) => const PrivacyPolicyScreen(),
                '/terms' : (context) => const TermsAndConditions(),
                '/signin': (context)=> const LoginScreen(),
                '/signup': (context)=> const SignUpScreen(),
                '/auth/riotcallback': (context)=> const RiotCallBackScreen(),
                '/cancel' : (context)=> const PaymentCancelled(),
                '/success' : (context)=> const PaymentSuccessful()
              },
            onGenerateRoute: (settings){

              switch (settings.name) {
                case '/home':
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const MainScreen());


                case '/privacy':
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const PrivacyPolicyScreen()
                  );
                case '/terms':
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const TermsAndConditions()
                  );
                case '/signin':
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const LoginScreen()
                  );

                case '/signup':
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const SignUpScreen()
                  );
                case '/auth/riotcallback':
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const RiotCallBackScreen()
                  );

                case '/cancel':
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const PaymentCancelled()
                  );
                case '/success':
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const PaymentSuccessful()
                  );

                default:
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (context) => const MainScreen()
                  );
              }
            },

            //   home:
            //   // MyHomePage(),
            // // const AdminHomeScreen()
            //   MainScreen()
              //  ApiData(),
              // AdminPage()
              // ApiToFirestoreScreen()
              // const ApiDataFromFirebase()
              // const SplashScreen()
            // HexWidget()
            //   const TeamBuilderScreen()
            // MainScreen()
            // LandingPage(),
          );
        });
  }
}
