import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_signin/auth/application/controllers/auth_controller.dart';
import 'package:firebase_signin/auth/application/widgets/google_sign_in_button.dart';
import 'package:firebase_signin/core/app_firebase_options.dart';
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
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  static SnackBar customSnackBar(
      {required String content, Color color = Colors.redAccent}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: color, letterSpacing: 0.5),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
                child: Column(
              children: [
                TextFormField(
                  controller: widget.emailTextController,
                ),
                TextFormField(
                  controller: widget.passwordTextController,
                ),
                ElevatedButton(
                    onPressed: () {

                    }, child: const Text("Email Register")),
                ElevatedButton(
                    onPressed: () {
                      
                    }, child: const Text("Email Sign In"))
              ],
            )),
            GoogleSignInButton(
              onPressed: () async {
                (await widget.authController.signInWithGoogle()).fold(
                    (failure) =>
                        MyHomePage.customSnackBar(content: failure.detail),
                    (user) {
                  debugPrint("Display Name: ${user.displayName}");
                  debugPrint("UUID: ${user.uid}");

                  debugPrint("Email: ${user.email}");
                  debugPrint(
                      "Email Verified: ${user.emailVerified}\nTenantd Id: ${user.tenantId}");

                  debugPrint("Phone Number: ${user.phoneNumber}");
                  debugPrint("Tenantd Id: ${user.tenantId}");

                  MyHomePage.customSnackBar(
                      content: "Welcome ${user.displayName}",
                      color: Colors.white);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
