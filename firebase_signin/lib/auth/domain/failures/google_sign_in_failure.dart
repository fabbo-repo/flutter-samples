import 'package:firebase_signin/auth/domain/failures/failure.dart';

/// Represents a google sign in error
class GoogleSignInFailure extends Failure {
  factory GoogleSignInFailure.fromFirebaseCode(final String code) {
    return const HttpRequestFailure(statusCode: unknownStatusCode, detail: "");
  }
}
