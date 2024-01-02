import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_signin/auth/domain/failures/email_register_failure.dart';
import 'package:firebase_signin/auth/domain/failures/email_sign_in_failure.dart';
import 'package:firebase_signin/auth/domain/failures/empty_failure.dart';
import 'package:firebase_signin/auth/domain/failures/failure.dart';
import 'package:firebase_signin/auth/domain/failures/google_sign_in_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  Future<Either<Failure, User>> registerWithEmail(
      {required String email, required String password}) async {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential = await firbaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(EmailRegisterFailure.fromFirebaseCode(e.code));
    } catch (_) {
      return left(const EmptyFailure());
    }
  }

  Future<Either<Failure, User>> signInWithEmail(
      {required String email, required String password}) async {
    final FirebaseAuth firbaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential = await firbaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(EmailSignInFailure.fromFirebaseCode(e.code));
    } catch (_) {
      return left(const EmptyFailure());
    }
  }

  Future<Either<Failure, User>> signInWithGoogle() async {
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
        final UserCredential userCredential =
            await firbaseAuth.signInWithCredential(credential);

        return right(userCredential.user!);
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
