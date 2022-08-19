import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../models/model.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest request);
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure, Authentication>> register(RegisterRequest request);
  Future<Either<Failure, HomeObject>> getHomeData();
}
