import 'package:firebase_signin/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class PhoneView extends StatelessWidget {
  PhoneView({super.key, required this.authController});

  final TextEditingController phoneNumberTextController =
      TextEditingController();
  final TextEditingController smsCodeTextController = TextEditingController();
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
          child: Column(
        children: [
          TextFormField(
            controller: phoneNumberTextController,
          ),
          TextFormField(
            controller: smsCodeTextController,
          ),
          ElevatedButton(
              onPressed: () async {
                await authController.verifyPhoneNumber(
                    phoneNumber: phoneNumberTextController.text);
              },
              child: const Text("Send SMS")),
          ElevatedButton(
              onPressed: () async {
                await authController.verifyPhoneCode(
                    smsCode: smsCodeTextController.text);
              },
              child: const Text("Verify Code"))
        ],
      )),
    );
  }
}
