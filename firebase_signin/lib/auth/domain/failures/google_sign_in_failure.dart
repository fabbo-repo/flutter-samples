import 'package:firebase_signin/auth/domain/failures/failure.dart';

/// Represents a google sign in error
class GoogleSignInFailure extends Failure {
  const GoogleSignInFailure({required super.detail});

  factory GoogleSignInFailure.fromFirebaseCode(final String code) {
    if (code == "account-exists-with-different-credential") {
      return const GoogleSignInFailure(
          detail: "The account already exists with a different credential.");
    } else if (code == "invalid-credential") {
      return const GoogleSignInFailure(
          detail: "Error occurred while accessing credentials. Try again.");
    } else if (code == "user-disabled") {
      return const GoogleSignInFailure(detail: "User disabled.");
    }
    return const GoogleSignInFailure(
        detail: "Error occurred using Google Sign-In. Try again.");
  }
}
