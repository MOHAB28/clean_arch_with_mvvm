import 'package:dartz/dartz.dart';

import 'package:cla/data/network/failure.dart';

import '../repository/repository.dart';
import 'base_usecase.dart';

class ForgotPasswordUseCase implements BaseUseCase<String, String> {
  final Repository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String input) async {
    return await _repository.forgotPassword(input);
  }
}