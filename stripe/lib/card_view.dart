import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class CardView extends StatefulWidget {
  final CardFormEditController cardController = CardFormEditController();

  CardView({super.key});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay with Card"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                  children: [
            CardFormField(
              controller: widget.cardController,
              enablePostalCode: false,
              countryCode: "ES",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (widget.cardController.details.complete) {
                    const billing = BillingDetails(email: "test@correo.com");
          
                    final payMethod = await Stripe.instance.createPaymentMethod(
                        params: const PaymentMethodParams.card(
                            paymentMethodData:
                                PaymentMethodData(billingDetails: billing)));
          
                    debugPrint(payMethod.id);
                    http.Response res = await http.post(
                        Uri.parse("http://10.0.0.2:8080/api/pay"),
                        headers: {"Content-Type": "application/json"},
                        body: json
                            .encode({"subs_id": "1", "pay_id": payMethod.id}));
          
                    if (res.statusCode != 400) {
                      final Map jsonBody = json.decode(res.body);
                      final String clientSecret = jsonBody["client_secret"];
                      final bool requiresActions = jsonBody["requires_action"];
                      if (!requiresActions) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Successfuly paid")));
                      } else {
                        final payIntent =
                            await Stripe.instance.handleNextAction(clientSecret);
                        debugPrint("Intent Status: ${payIntent.status}");
                        if (payIntent.status ==
                            PaymentIntentsStatus.RequiresConfirmation) {
                          http.Response res = await http.post(
                              Uri.parse("http://10.0.0.2:8080/api/pay/confirm"),
                              headers: {"Content-Type": "application/json"},
                              body: json.encode({"pay_id": payIntent.id}));
                          if (res.statusCode != 400) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Successfuly paid")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Confirmation failed")));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Successfuly paid")));
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Payment failed")));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("The form is not complete")));
                  }
                },
                child: const Text("Pay"))
                  ],
                ),
          )),
    );
  }
}
