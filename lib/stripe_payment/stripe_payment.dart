

import 'dart:convert';
import 'package:app/consolePrintWithColor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stripe.buildWebCard(
          controller: CardEditController(
              initialDetails: const CardFieldInputDetails(complete: true)
          ),
        dangerouslyUpdateFullCardDetails: true,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        style: CardStyle(
          borderColor: Colors.amber,
          backgroundColor: Colors.black

        )
      ),
    );
  }
}


paymentDialogue(BuildContext context){
  showBottomSheet(context: context,
      builder: (context){
    return SizedBox(
      height: 100,
      width: 100,
      child: null
    );
      });
}

showPayment(){
  return Scaffold(
    body: Stripe.buildWebCard(
        controller: CardEditController(
            initialDetails: const CardFieldInputDetails(complete: true)
        )
    ),
  );

}


Future<void> makePayment(BuildContext context) async {
  try {
    //STEP 1: Create Payment Intent
    var paymentIntent = await createPaymentIntent('100', 'USD');


    Stripe.buildWebCard(
      controller: CardEditController(
        initialDetails: const CardFieldInputDetails(complete: true)
      )
    );


    //
    // //STEP 2: Initialize Payment Sheet
    // await Stripe.instance
    //     .initPaymentSheet(
    //     paymentSheetParameters: SetupPaymentSheetParameters(
    //         paymentIntentClientSecret: paymentIntent!['client_secret'], //Gotten from payment intent
    //         style: ThemeMode.light,
    //         merchantDisplayName: 'Ikay'))
    //     .then((value) {});
    //
    // //STEP 3: Display Payment sheet
    // displayPaymentSheet(context);
  } catch (err) {
    throw Exception(err);
  }
}


createPaymentIntent(String amount, String currency) async {
  try {
    //Request body
    Map<String, dynamic> body = {
      'amount': amount*100,
      'currency': currency,
    };

    //Make post request to Stripe
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    return json.decode(response.body);
  } catch (err) {
    throw Exception(err.toString());
  }
}




displayPaymentSheet(BuildContext context) async {
  try {
    await Stripe.instance.presentPaymentSheet().then((value) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                SizedBox(height: 10.0),
                Text("Payment Successful!"),
              ],
            ),
          ));

      var paymentIntent = null;
    }).onError((error, stackTrace) {
      throw Exception(error);
    });
  } on StripeException catch (e) {
    print('Error is:---> $e');
    AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              Text("Payment Failed"),
            ],
          ),
        ],
      ),
    );
  } catch (e) {
    print('$e');
  }
}