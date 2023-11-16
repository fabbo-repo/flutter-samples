import 'package:firebase_signin/auth/domain/failures/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Provides specification for value objects
abstract class AbstractValue<T> {
  ///
  const AbstractValue();

  /// getter for value
  Either<Failure, T> get value;

  /// Form validate handler, return error message in case of Failure
  String? get validate =>
      value.fold((failure) => failure.detail, (value) => null);
}
