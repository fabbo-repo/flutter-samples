import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_signin/failures/email_register_failure.dart';
import 'package:firebase_signin/failures/email_sign_in_failure.dart';
import 'package:firebase_signin/failures/empty_failure.dart';
import 'package:firebase_signin/failures/failure.dart';
import 'package:firebase_signin/failures/google_sign_in_failure.dart';
import 'package:firebase_signin/failures/phone_sign_in_failure.dart';
import 'package:firebase_signin/failures/phone_verify_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  void Function(User)? onSignIn;
  String verificationId = "";

  AuthController() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
        if (onSignIn != null) {
          onSignIn!(user);
        }
      }
    });
  }

  Future<Either<Failure, void>> registerWithEmail(
      {required String email, required String password}) async {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    try {
      await firbaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(EmailRegisterFailure.fromFirebaseCode(e.code));
    } catch (_) {
      return left(const EmptyFailure());
    }
  }

  bool isEmailVerified() {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    return firbaseAuth.currentUser!.emailVerified;
  }

  Future<void> sendEmailVerification() async {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    await firbaseAuth.currentUser!.sendEmailVerification();
  }

  Future<Either<Failure, void>> signInWithEmail(
      {required String email, required String password}) async {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    try {
      await firbaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(EmailSignInFailure.fromFirebaseCode(e.code));
    } catch (_) {
      return left(const EmptyFailure());
    }
  }

  Future<void> verifyPhoneNumber(
      {required String phoneNumber, bool linkWithUser = false}) async {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    await firbaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          try {
            if (linkWithUser) {
              firbaseAuth.currentUser!.linkWithCredential(phoneAuthCredential);
            } else {
              await firbaseAuth.signInWithCredential(phoneAuthCredential);
            }
          } on FirebaseAuthException catch (e) {
            debugPrint(PhoneSignInFailure.fromFirebaseCode(e.code).detail);
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          debugPrint(PhoneVerifyFailure.fromFirebaseCode(error.code).detail);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        });
  }

  Future<Either<Failure, void>> verifyPhoneCode(
      {required String smsCode}) async {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    try {
      await firbaseAuth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode));

      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(PhoneVerifyFailure.fromFirebaseCode(e.code));
    } catch (_) {
      return left(const EmptyFailure());
    }
  }

  Future<Either<Failure, void>> signInWithGoogle() async {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        await firbaseAuth.signInWithCredential(credential);

        return right(null);
      } on FirebaseAuthException catch (e) {
        return left(GoogleSignInFailure.fromFirebaseCode(e.code));
      } catch (_) {
        return left(const EmptyFailure());
      }
    }
    return left(const EmptyFailure());
  }

  Future<bool> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (_) {
      return false;
    }
  }
}
