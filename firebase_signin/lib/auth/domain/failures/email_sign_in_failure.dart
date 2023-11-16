import 'package:firebase_signin/auth/domain/failures/failure.dart';

/// Represents an email sign in error
class EmailSignInFailure extends Failure {
  factory EmailSignInFailure.fromFirebaseCode(final String code) {
    return const HttpRequestFailure(statusCode: unknownStatusCode, detail: "");
  }
}
