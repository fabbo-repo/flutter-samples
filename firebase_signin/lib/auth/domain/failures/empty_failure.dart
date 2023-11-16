import 'package:firebase_signin/auth/domain/failures/failure.dart';

/// Expected value is null or empty
class EmptyFailure extends Failure {
  const EmptyFailure() : super(detail: "");
}
