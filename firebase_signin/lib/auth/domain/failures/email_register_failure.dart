import 'package:firebase_signin/auth/domain/failures/failure.dart';

class EmailRegisterFailure extends Failure {
  const EmailRegisterFailure({required super.detail});

  factory EmailRegisterFailure.fromFirebaseCode(final String code) {
    if (code == "weak-password") {
      return const EmailRegisterFailure(
          detail: "Please enter a stronger password.");
    } else if (code == "invalid-email") {
      return const EmailRegisterFailure(
          detail: "Email is not valid or badly formatted.");
    } else if (code == "email-already-in-use") {
      return const EmailRegisterFailure(
          detail: "An account already exists for that email.");
    } else if (code == "operation-not-allowed") {
      return const EmailRegisterFailure(
          detail: "Cannot create user with email and password.");
    }
    return const EmailRegisterFailure(
        detail: "Error occurred using Email Register. Try again.");
  }
}
