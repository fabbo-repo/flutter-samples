import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  final Future<void> Function() onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                await widget.onPressed();

                setState(() {
                  _isSigningIn = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
