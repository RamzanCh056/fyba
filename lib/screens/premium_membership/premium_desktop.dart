import 'package:app/consolePrintWithColor.dart';
import 'package:app/constants/app_sizes.dart';
import 'package:app/model/subscription_model.dart';
import 'package:app/providers/subscription_provider.dart';
import 'package:app/screens/privacy_policy/terms_and_conditions.dart';
import 'package:app/stripe_payment/stripe_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../../constants/app_colors.dart';
import '../../stripe_payment/stripe_payment.dart';
import '../privacy_policy/privacy_policy.dart';
import 'custom_list_tile.dart';


typedef _CheckoutSessionSnapshot = DocumentSnapshot<Map<String, dynamic>>;

class PremiumDesktopScreen extends StatefulWidget {
  const PremiumDesktopScreen({
    required this.dismiss,
    super.key});
  final VoidCallback dismiss;

  @override
  State<PremiumDesktopScreen> createState() => _PremiumDesktopScreenState();
}

class _PremiumDesktopScreenState extends State<PremiumDesktopScreen> {


  late Stream<_CheckoutSessionSnapshot> _sessionStream;


  var _checkoutSessionId = '';

  getCheckoutSessionId(String productId,String priceId)async{
    final price = priceId;

    final docRef = await FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("checkout_sessions")
        .add({
      "client": "web",
      "mode": "subscription",
      "price": price,
      "success_url": 'https://www.fyba.app/success',
      // "success_url": 'http://localhost:52589/success',
      "cancel_url": 'https://www.fyba.app/cancel',
      "subscription_type": priceId=="price_1OEywTGNqLxAA3gqKnj5LyhP"?"Yearly":"Monthly"
    });
    setState(() => _checkoutSessionId = docRef.id);
    printLog("Session Id: ${_checkoutSessionId}");
    String subscriptionType=priceId=="price_1OEywTGNqLxAA3gqKnj5LyhP"?"Yearly":"Monthly";
    DateTime subscriptionExpiry=subscriptionType=="Yearly"?DateTime(DateTime.now().year+1,DateTime.now().month,DateTime.now().day):DateTime(DateTime.now().year,DateTime.now().month+1,DateTime.now().day);

    PremiumSubscriptionModel subscription=PremiumSubscriptionModel(
      subscriptionId: _checkoutSessionId,
      subscriptionAmount: priceId=="price_1OEywTGNqLxAA3gqKnj5LyhP"?"23":"2.9",
      subscriptionDate: DateTime.now().toString(),
      subscriptionType: priceId=="price_1OEywTGNqLxAA3gqKnj5LyhP"?"Yearly":"Monthly",
      subscriptionExpiryDate: subscriptionExpiry.toString(),
      subscriptionStatus: "pending"
    );

    await Provider.of<SubscriptionProvider>(context,listen:false).addSubscription(subscription);
    _sessionStream = FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("checkout_sessions")
        .doc(_checkoutSessionId)
        .snapshots();
    print(_checkoutSessionId.toString());
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(

        // height: responsiveHeight(590, context),
        width: responsiveWidth(1043, context),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.mainDarkColor,
            border: Border.all(color: const Color(0xFFD4239B), width: 1)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Get Premium",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Aperiam minima amet reprehenderit eaque at ab vero. Suscipit inventore neque occaecati. Quo quia quidem aut inventore dolorem ut velit architecto sit. Magni ducimus et recusandae.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFF151238),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                              onTap: () async{


                                setState(() {
                                  currentIndex = 0;

                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(7),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: currentIndex == 0
                                      ? const Color(0xFF494390)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  "Yearly",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: currentIndex == 0
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: currentIndex == 0
                                        ? Colors.white
                                        : const Color(0x50ffffff),
                                  ),
                                ),
                              ),
                            )),
                        Expanded(
                            child: GestureDetector(
                              onTap: () async{

                                setState(() {
                                  currentIndex = 1;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(7),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: currentIndex == 1
                                      ? const Color(0xFF494390)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  "Monthly",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: currentIndex == 1
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: currentIndex == 1
                                        ? Colors.white
                                        : const Color(0x50ffffff),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: responsiveHeight(20, context)),
                  Container(

                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF151238),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "\$",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            Text(
                              currentIndex==0?"23":"2.9",
                              style: const TextStyle(
                                fontSize: 54,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            Text(
                              currentIndex==0?" / per year":" / per month",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Color(0x50FFFFFF),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "\$${currentIndex==0?"23 per year including all taxes.":"2.9 per month including all taxes."} ",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Color(0x50FFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: ()async{
                      if(currentIndex==0){
                        await getCheckoutSessionId("prod_P356hhET0CQlkc","price_1OEywTGNqLxAA3gqKnj5LyhP");
                        await checkoutDialoge(context);
                      }else{
                        await getCheckoutSessionId("prod_P359JpIX4Vh0fI","price_1OEyyuGNqLxAA3gqVm9UiIgq");
                        await checkoutDialoge(context);
                        // await launchUrl(Uri.parse("https://buy.stripe.com/test_14kfZUgri0Yl24g5kk"));
                      }
                      // await makePayment(context);
                    },
                    child: Container(
                      height: responsiveHeight(50, context),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFD4239B),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFFD4239B),
                                blurRadius: 10,
                                spreadRadius: 1)
                          ]),
                      child: const Text(
                        "Get Premium",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, "/terms");
                      },
                      child: const Text(
                        "Term & Conditions",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0x50FFFFFF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, "/privacy");
                      },
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0x50FFFFFF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF151238),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "What you’ll get?",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Key Features:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0x50FFFFFF),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomListTile(title: "Qui porro et",isBackground: true),
                    SizedBox(height: 10),
                    CustomListTile(title: "Provident eos vel"),
                    SizedBox(height: 10),
                    CustomListTile(title: "Necessitatibus sit voluptates",isBackground: true),
                    SizedBox(height: 10),
                    CustomListTile(title: "Autem culpa veritatis"),
                    SizedBox(height: 10),
                    CustomListTile(title: "Aperiam consequatur unde",isBackground: true),
                    SizedBox(height: 10),
                    CustomListTile(title: "Quam ipsa accusantium"),

                  ],
                ),
              ),
            ),
            const SizedBox(width: 30),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: widget.dismiss,
                child: CircleAvatar(
                    backgroundColor: Color(0xFFD4239B),
                    child: Icon(Icons.close,color: Colors.white,)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> checkoutDialoge(BuildContext context) {
    printLog("Check out dialog");
    return showDialog(
                          context: context,
                          builder: (context){
                            return StatefulBuilder(builder: (context,StateSetter setState){
                              return StreamBuilder(
                                stream: _sessionStream,
                                  builder: (context,AsyncSnapshot<_CheckoutSessionSnapshot> snapshot){
                                    if (snapshot.connectionState != ConnectionState.active) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError || snapshot.hasData == false) {
                                      return const Text('Something went wrong');
                                    }
                                    final data = snapshot.requireData.data()!;
                                    printLog(">>>>>>>>>>>>>>>>>>>>>>>>>${data}");
                                    if (data.containsKey('sessionId') && data.containsKey('url')) {
                                      html.window.location.href = data['url'] as String; // open the new window with Stripe Checkout Page URL
                                      // html.window.open(data['url'], '_blank');
                                      return const SizedBox();
                                    } else if (data.containsKey('error')) {
                                      return Text(
                                        data['error']['message'] as String? ?? 'Error processing payment.',
                                        style: TextStyle(
                                          color: Theme.of(context).errorColor,
                                        ),
                                      );
                                    } else {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  });
                            });
                          });
  }
}



// premiumDesktopView(BuildContext context,VoidCallback dismiss) {
//
//   int currentIndex = 0;
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         backgroundColor: const Color(0xFF0A091D),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: StatefulBuilder(
//           builder:
//               (BuildContext context, void Function(void Function()) setState) {
//             return SingleChildScrollView(
//               child: Container(
//
//                 // height: responsiveHeight(590, context),
//                 width: responsiveWidth(1043, context),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: const Color(0xFFD4239B), width: 1)),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Get Premium",
//                             style: TextStyle(
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white),
//                           ),
//                           const SizedBox(height: 5),
//                           const Text(
//                             "Aperiam minima amet reprehenderit eaque at ab vero. Suscipit inventore neque occaecati. Quo quia quidem aut inventore dolorem ut velit architecto sit. Magni ducimus et recusandae.",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.white),
//                           ),
//                           const SizedBox(height: 20),
//                           Container(
//                             height: 60,
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(7),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(100),
//                               color: const Color(0xFF151238),
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                     child: GestureDetector(
//                                   onTap: () async{
//
//
//                                     setState(() {
//                                       currentIndex = 0;
//
//                                     });
//                                   },
//                                   child: Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.all(7),
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(26),
//                                       color: currentIndex == 0
//                                           ? const Color(0xFF494390)
//                                           : Colors.transparent,
//                                     ),
//                                     child: Text(
//                                       "Yearly",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: currentIndex == 0
//                                             ? FontWeight.w600
//                                             : FontWeight.w400,
//                                         color: currentIndex == 0
//                                             ? Colors.white
//                                             : const Color(0x50ffffff),
//                                       ),
//                                     ),
//                                   ),
//                                 )),
//                                 Expanded(
//                                     child: GestureDetector(
//                                   onTap: () async{
//
//                                     setState(() {
//                                       currentIndex = 1;
//                                     });
//                                   },
//                                   child: Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.all(7),
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(26),
//                                       color: currentIndex == 1
//                                           ? const Color(0xFF494390)
//                                           : Colors.transparent,
//                                     ),
//                                     child: Text(
//                                       "Monthly",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: currentIndex == 1
//                                             ? FontWeight.w600
//                                             : FontWeight.w400,
//                                         color: currentIndex == 1
//                                             ? Colors.white
//                                             : const Color(0x50ffffff),
//                                       ),
//                                     ),
//                                   ),
//                                 )),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: responsiveHeight(20, context)),
//                           Container(
//
//                             padding: const EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: const Color(0xFF151238),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: const [
//                                     Text(
//                                       "\$",
//                                       style: TextStyle(
//                                         fontSize: 32,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color(0xFFFFFFFF),
//                                       ),
//                                     ),
//                                     Text(
//                                       "140",
//                                       style: TextStyle(
//                                         fontSize: 54,
//                                         fontWeight: FontWeight.w700,
//                                         color: Color(0xFFFFFFFF),
//                                       ),
//                                     ),
//                                     Text(
//                                       " / per year",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color(0x50FFFFFF),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const Text(
//                                   "\$12 per month including all taxes.",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w400,
//                                     color: Color(0x50FFFFFF),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           InkWell(
//                             onTap: ()async{
//                               if(currentIndex==0){
//                                 // Navigator.pop(context);
//                                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>Payment()));
//                                // paymentDialogue(context);
//                                 // await launchUrl(Uri.parse("https://buy.stripe.com/test_5kA9Bw1wodL7fV63cd"));
//                               }else{
//                                 // await launchUrl(Uri.parse("https://buy.stripe.com/test_14kfZUgri0Yl24g5kk"));
//                               }
//                               // await makePayment(context);
//                             },
//                             child: Container(
//                               height: responsiveHeight(50, context),
//                               width: double.infinity,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: const Color(0xFFD4239B),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                         color: Color(0xFFD4239B),
//                                         blurRadius: 10,
//                                         spreadRadius: 1)
//                                   ]),
//                               child: const Text(
//                                 "Get Premium",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 18,
//                                     color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           const Center(
//                             child: Text(
//                               "Term & Conditions",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0x50FFFFFF),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           const Center(
//                             child: Text(
//                               "Privacy Policy",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                   color: Color(0x50FFFFFF)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(15),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF151238),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child:  Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: const [
//                             Text(
//                               "What you’ll get?",
//                               style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               "Key Features:",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0x50FFFFFF),
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             CustomListTile(title: "Qui porro et",isBackground: true),
//                             SizedBox(height: 10),
//                             CustomListTile(title: "Provident eos vel"),
//                             SizedBox(height: 10),
//                             CustomListTile(title: "Necessitatibus sit voluptates",isBackground: true),
//                             SizedBox(height: 10),
//                             CustomListTile(title: "Autem culpa veritatis"),
//                             SizedBox(height: 10),
//                             CustomListTile(title: "Aperiam consequatur unde",isBackground: true),
//                             SizedBox(height: 10),
//                             CustomListTile(title: "Quam ipsa accusantium"),
//
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 30),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: InkWell(
//                         onTap: dismiss,
//                         child: CircleAvatar(
//                           backgroundColor: Color(0xFFD4239B),
//                             child: Icon(Icons.close,color: Colors.white,)),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }


