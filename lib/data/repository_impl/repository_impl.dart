import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../mapper/mapper.dart';
import '../../domain/models/model.dart';
import '../data_sources/remote_data_sources.dart';
import '../network/error_handler.dart';
import '../network/networl_info.dart';
import '../network/requests.dart';
import '../network/failure.dart';
import '../../domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSources;
  final NetworkInfo _networkInfo;
  RepositoryImpl(this._remoteDataSources, this._networkInfo);
  @override
  Future<Either<Failure, Authentication>> login(LoginRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSources.login(request);
        if (response.status == ApiInternalStatus.success) {
          return Right(response.toDomain());
        } else {
          return Left(
            Failure(
              ApiInternalStatus.failure,
              DataSource.defaultError.message,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call API
        final response = await _remoteDataSources.forgotPassword(email);

        if (response.status == ApiInternalStatus.success) {
          debugPrint('respomee  ggg ${response.status}');
          // success
          // return right
          return Right(response.toDomain());
        } else {
          // failure
          // return left
          debugPrint('respomee  left ${response.status}');
          return Left(
            Failure(
              ApiInternalStatus.failure,
              DataSource.defaultError.message,
            ),
          );
        }
      } catch (error) {
        debugPrint('ErrorHandler  ');
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      debugPrint('noInternetConnection  ');
      // return network connection error
      // return left
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest request) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSources.register(request);

        if (response.status == ApiInternalStatus.success) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(
            Failure(
              ApiInternalStatus.failure,
              DataSource.defaultError.message,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
  
  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSources.getHomeData();

        if (response.status == ApiInternalStatus.success) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(
            Failure(
              ApiInternalStatus.failure,
              DataSource.defaultError.message,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
}
