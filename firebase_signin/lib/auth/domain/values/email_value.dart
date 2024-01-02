import 'package:firebase_signin/auth/domain/failures/failure.dart';
import 'package:firebase_signin/auth/domain/failures/invalid_value_failure.dart';
import 'package:firebase_signin/auth/domain/values/abstract_value.dart';
import 'package:fpdart/fpdart.dart';

/// User Email value
class UserEmail extends AbstractValue<String> {
  @override
  Either<Failure, String> get value => _value;
  final Either<Failure, String> _value;

  factory UserEmail(String input) {
    return UserEmail._(
      _validate(input),
    );
  }

  const UserEmail._(this._value);
}

/// * minLength: 1
/// * valid email regex
Either<Failure, String> _validate(String input) {
  if (input.isNotEmpty &&
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(input)) {
    return right(input);
  }
  String message = input.isEmpty ? "Email needed" : "Email not valid";
  return left(
    InvalidValueFailure(
      detail: message,
    ),
  );
}
