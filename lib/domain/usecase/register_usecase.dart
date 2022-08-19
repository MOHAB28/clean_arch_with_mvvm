import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../models/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class RegisterUseCase
    extends BaseUseCase<RegisterUsecaseInput, Authentication> {
  final Repository _repository;
  RegisterUseCase(this._repository);
  @override
  Future<Either<Failure, Authentication>> call(
      RegisterUsecaseInput input) async {
    return await _repository.register(
      RegisterRequest(
        countryMobileCode: input.countryMobileCode,
        userName: input.userName,
        mobileNumber: input.mobileNumber,
        email: input.email,
        password: input.password,
        profilePicture: input.profilePicture,
      ),
    );
  }
}

class RegisterUsecaseInput {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;

  RegisterUsecaseInput({
    required this.userName,
    required this.countryMobileCode,
    required this.mobileNumber,
    required this.email,
    required this.password,
    required this.profilePicture,
  });
}
