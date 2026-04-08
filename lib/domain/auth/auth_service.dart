import 'package:dartz/dartz.dart';
import 'package:qflow/domain/core/failures.dart';

abstract class IAuthService {
  Future<Either<MainFailure, Unit>> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required String fullName,
  });

  Future<Either<MainFailure, Unit>> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  });

  Future<Either<MainFailure, Unit>> signInWithGoogle();
}
