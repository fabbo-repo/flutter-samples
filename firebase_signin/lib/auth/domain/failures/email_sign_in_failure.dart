import 'package:firebase_signin/auth/domain/failures/failure.dart';

class EmailSignInFailure extends Failure {
  const EmailSignInFailure({required super.detail});

  factory EmailSignInFailure.fromFirebaseCode(final String code) {
    if (code == "wrong-password") {
      return const EmailSignInFailure(detail: "Wrong password.");
    } else if (code == "invalid-email") {
      return const EmailSignInFailure(
          detail: "Email is not valid or badly formatted.");
    } else if (code == "user-not-found") {
      return const EmailSignInFailure(
          detail: "User not found.");
    } else if (code == "user-disabled") {
      return const EmailSignInFailure(detail: "User disabled.");
    }
    return const EmailSignInFailure(
        detail: "Error occurred using Email Sign-In. Try again.");
  }
}
