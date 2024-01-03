import 'package:firebase_signin/controllers/auth_controller.dart';
import 'package:firebase_signin/main.dart';
import 'package:flutter/material.dart';

class EmailView extends StatelessWidget {
  EmailView({super.key, required this.authController});

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
          child: Column(
        children: [
          TextFormField(
            controller: emailTextController,
          ),
          TextFormField(
            controller: passwordTextController,
          ),
          ElevatedButton(
              onPressed: () async {
                await (await authController.registerWithEmail(
                        email: emailTextController.text,
                        password: passwordTextController.text))
                    .fold(
                        (failure) async => MyHomePage.customSnackBar(
                            context: context,
                            content: failure.detail), (user) async {
                  if (!authController.isEmailVerified()) {
                    await authController.sendEmailVerification();
                  }
                });
              },
              child: const Text("Email Register")),
          ElevatedButton(
              onPressed: () async {
                await (await authController.signInWithEmail(
                        email: emailTextController.text,
                        password: passwordTextController.text))
                    .fold(
                        (failure) async => MyHomePage.customSnackBar(
                            context: context,
                            content: failure.detail), (user) async {
                  if (!authController.isEmailVerified()) {
                    await authController.sendEmailVerification();
                  }
                });
              },
              child: const Text("Email Sign In"))
        ],
      )),
    );
  }
}
