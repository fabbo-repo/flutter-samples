import 'package:firebase_signin/failures/failure.dart';

class PhoneVerifyFailure extends Failure {
  const PhoneVerifyFailure({required super.detail});

  factory PhoneVerifyFailure.fromFirebaseCode(final String code) {
    if (code == "invalid-phone-number") {
      return const PhoneVerifyFailure(
          detail: "Invalid phone number.");
    } else if (code == "user-disabled") {
      return const PhoneVerifyFailure(detail: "User disabled.");
    }
    return const PhoneVerifyFailure(
        detail: "Error occurred using Phone verify. Try again.");
  }
}
