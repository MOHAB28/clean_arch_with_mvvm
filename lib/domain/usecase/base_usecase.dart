import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';

abstract class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> call(In input);
}

class NoParams {
  
}