import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../models/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class GetHomeDataUsecase extends BaseUseCase<NoParams, HomeObject> {
  final Repository _repository;
  GetHomeDataUsecase(this._repository);

  @override
  Future<Either<Failure, HomeObject>> call(NoParams input) async {
    return await _repository.getHomeData();
  }
}
