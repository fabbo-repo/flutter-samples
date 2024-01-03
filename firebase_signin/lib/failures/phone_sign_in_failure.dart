import 'package:firebase_signin/failures/failure.dart';

class PhoneSignInFailure extends Failure {
  const PhoneSignInFailure({required super.detail});

  factory PhoneSignInFailure.fromFirebaseCode(final String code) {
    if (code == "account-exists-with-different-credential") {
      return const PhoneSignInFailure(
          detail: "The account already exists with a different credential.");
    } else if (code == "invalid-credential") {
      return const PhoneSignInFailure(
          detail: "Error occurred while accessing credentials. Try again.");
    } else if (code == "user-disabled") {
      return const PhoneSignInFailure(detail: "User disabled.");
    }
    return const PhoneSignInFailure(
        detail: "Error occurred using Phone Sign-In. Try again.");
  }
}
