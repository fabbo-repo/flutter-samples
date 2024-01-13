import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_signin/controllers/auth_controller.dart';
import 'package:firebase_signin/core/app_firebase_options.dart';
import 'package:firebase_signin/views/email_view.dart';
import 'package:firebase_signin/views/phone_view.dart';
import 'package:firebase_signin/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: AppFirebaseOptions.currentPlatformOptions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final AuthController authController = AuthController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  static void customSnackBar(
      {required BuildContext context,
      required String content,
      Color color = Colors.redAccent}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: color, letterSpacing: 0.5),
      ),
    ));
  }

  static void printUserData(BuildContext context, User user) async {
    debugPrint("Display Name: ${user.displayName}");
    debugPrint("UUID: ${user.uid}");

    debugPrint("Email: ${user.email}");
    debugPrint("Email Verified: ${user.emailVerified}");

    debugPrint("Provider Data: ${user.providerData}");

    debugPrint("Phone Number: ${user.phoneNumber}");
    debugPrint("Tenantd Id: ${user.tenantId}");
    debugPrint("Id token: ${await user.getIdToken()}");

    // ignore: use_build_context_synchronously
    MyHomePage.customSnackBar(
        context: context,
        content: "Welcome ${user.displayName}",
        color: Colors.white);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    widget.authController.onSignIn = (user) {
      MyHomePage.printUserData(context, user);
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              EmailView(
                authController: widget.authController,
              ),
              PhoneView(
                authController: widget.authController,
              ),
              GoogleSignInButton(
                onPressed: () async {
                  (await widget.authController.signInWithGoogle()).fold(
                      (failure) => MyHomePage.customSnackBar(
                          context: context, content: failure.detail),
                      (user) {});
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    await widget.authController.signOut();
                  },
                  child: const Text("Sign Out")),
            ],
          ),
        ),
      ),
    );
  }
}
