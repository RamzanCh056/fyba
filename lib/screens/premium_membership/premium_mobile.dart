import 'package:app/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../consolePrintWithColor.dart';
import '../../model/subscription_model.dart';
import '../../providers/subscription_provider.dart';
import 'custom_list_tile.dart';

import 'dart:html'as html;


typedef _CheckoutSessionSnapshot = DocumentSnapshot<Map<String, dynamic>>;
class PremiumMobile extends StatefulWidget {
  const PremiumMobile({
    required this.dismiss,super.key});
  final VoidCallback dismiss;
  @override
  State<PremiumMobile> createState() => _PremiumMobileState();
}

class _PremiumMobileState extends State<PremiumMobile> {


  int currentIndex = 0;

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
      "cancel_url": 'https://www.fyba.app/cancel',
      "subscription_type": priceId=="price_1OEywTGNqLxAA3gqKnj5LyhP"?"Yearly":"Monthly"
    });
    setState(() => _checkoutSessionId = docRef.id);
    String subscriptionType=priceId=="price_1OEywTGNqLxAA3gqKnj5LyhP"?"Yearly":"Monthly";
    DateTime subscriptionExpiry=subscriptionType=="Yearly"?DateTime(DateTime.now().year+1,DateTime.now().month,DateTime.now().day):DateTime(DateTime.now().year,DateTime.now().month+1,DateTime.now().day);

    PremiumSubscriptionModel subscription=PremiumSubscriptionModel(
        subscriptionId: _checkoutSessionId,
        subscriptionAmount: priceId=="price_1OEywTGNqLxAA3gqKnj5LyhP"?"23":"2.9",
        subscriptionDate: DateTime.now().toString(),
        subscriptionType: priceId=="price_1OEywTGNqLxAA3gqKnj5LyhP"?"Yearly":"Monthly",
        subscriptionStatus: "pending",
        subscriptionExpiryDate: subscriptionExpiry.toString()
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
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD4239B), width: 1)),

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: widget.dismiss,
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFD4239B),
                    child: Icon(Icons.close,color: Colors.white,)),
              ),
            ),
            const Text(
              "Get Premium",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            const SizedBox(height: 5),
            const Text(
              "Aperiam minima amet reprehenderit eaque at ab vero. Suscipit inventore neque occaecati. Quo quia quidem aut inventore dolorem ut velit architecto sit. Magni ducimus et recusandae.",
              style: TextStyle(
                  fontSize: 14,
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
                        onTap: () {
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
                              fontSize: 15,
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
                        onTap: () {
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
                              fontSize: 15,
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
            const SizedBox(height: 20),
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
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      Text(
                        currentIndex==0?"23":"2.9",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      Text(
                        currentIndex==0?" / per year":" / per month",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0x50FFFFFF),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "\$${currentIndex==0?"23 per year including all taxes.":"2.9 per month including all taxes."} ",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0x50FFFFFF),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF151238),
                borderRadius: BorderRadius.circular(10),
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const[
                  Text(
                    "What you’ll get?",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Key Features:",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: Color(0x50FFFFFF),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomListTile(title: "Qui porro et",isBackground: true,isDesktop: false,),
                  SizedBox(height: 10),
                  CustomListTile(title: "Provident eos vel",isDesktop: false,),
                  SizedBox(height: 10),
                  CustomListTile(title: "Necessitatibus sit voluptates",isBackground: true,isDesktop: false,),
                  SizedBox(height: 10),
                  CustomListTile(title: "Autem culpa veritatis",isDesktop: false,),
                  SizedBox(height: 10),
                  CustomListTile(title: "Aperiam consequatur unde",isBackground: true,isDesktop: false,),
                  SizedBox(height: 10),
                  CustomListTile(title: "Quam ipsa accusantium",isDesktop: false,),

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
                height: 50,
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
            const Center(
              child: Text(
                "Term & Conditions",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0x50FFFFFF),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                "Privacy Policy",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0x50FFFFFF)),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<dynamic> checkoutDialoge(BuildContext context) {
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



premiumMobileView(BuildContext context) {
  int currentIndex = 0;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF0A091D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4239B), width: 1)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 20,
                          backgroundColor: Color(0xFFD4239B),
                          child: Icon(Icons.close,color: Colors.white,)),
                    ),
                    const Text(
                      "Get Premium",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Aperiam minima amet reprehenderit eaque at ab vero. Suscipit inventore neque occaecati. Quo quia quidem aut inventore dolorem ut velit architecto sit. Magni ducimus et recusandae.",
                      style: TextStyle(
                          fontSize: 14,
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
                                onTap: () {
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
                                      fontSize: 15,
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
                                onTap: () {
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
                                      fontSize: 15,
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
                    const SizedBox(height: 20),
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
                            children: const [
                              Text(
                                "\$",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              Text(
                                "140",
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              Text(
                                " / per year",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0x50FFFFFF),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "\$12 per month including all taxes.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0x50FFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151238),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const[
                          Text(
                            "What you’ll get?",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Key Features:",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                              color: Color(0x50FFFFFF),
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomListTile(title: "Qui porro et",isBackground: true,isDesktop: false,),
                          SizedBox(height: 10),
                          CustomListTile(title: "Provident eos vel",isDesktop: false,),
                          SizedBox(height: 10),
                          CustomListTile(title: "Necessitatibus sit voluptates",isBackground: true,isDesktop: false,),
                          SizedBox(height: 10),
                          CustomListTile(title: "Autem culpa veritatis",isDesktop: false,),
                          SizedBox(height: 10),
                          CustomListTile(title: "Aperiam consequatur unde",isBackground: true,isDesktop: false,),
                          SizedBox(height: 10),
                          CustomListTile(title: "Quam ipsa accusantium",isDesktop: false,),

                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Container(
                      height: 50,
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
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Term & Conditions",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0x50FFFFFF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0x50FFFFFF)),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}


