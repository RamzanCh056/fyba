// import 'package:flutter/material.dart';
// import 'package:flutter_stripe_web/card_field.dart';
// import 'package:flutter_stripe_web/flutter_stripe_web.dart';
//
// class PaymentForm extends StatefulWidget {
//   @override
//   _PaymentFormState createState() => _PaymentFormState();
// }
//
// class _PaymentFormState extends State<PaymentForm> {
//   WebStripeCardState _cardElement = CardElement();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16.0),
//           child: CardField(
//             cardElement: _cardElement,
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             // Create a payment method using Stripe.js
//             final result = await StripeJs.createPaymentMethod(
//               PaymentMethodData(
//                 type: 'card',
//                 card: _cardElement,
//               ),
//             );
//
//             // Handle the payment result
//             if (result.error != null) {
//               // Handle payment error (display error to the user)
//               print('Error: ${result.error}');
//             } else {
//               // Payment was successful, you can send the payment method ID to your server
//               print('Payment successful: ${result.paymentMethod.id}');
//             }
//           },
//           child: Text("Pay"),
//         ),
//       ],
//     );
//   }
// }
