import 'package:dio/dio.dart';

import '../../app/constants.dart';
import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;
  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      failure = _handler(error);
    } else {
      failure = DataSource.defaultError.getFailure();
    }
  }
}

Failure _handler(DioError error) {
  switch (error.type) {
    case DioErrorType.connectTimeout:
      return DataSource.connectTimeout.getFailure();
    case DioErrorType.sendTimeout:
      return DataSource.sendTimeout.getFailure();
    case DioErrorType.receiveTimeout:
      return DataSource.recieveTimeout.getFailure();
    case DioErrorType.response:
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return Failure(
          error.response?.statusCode ?? Constants.zero,
          error.response?.statusMessage ?? Constants.empty,
        );
      } else {
        return DataSource.defaultError.getFailure();
      }
    case DioErrorType.cancel:
      return DataSource.cancel.getFailure();
    case DioErrorType.other:
      return DataSource.defaultError.getFailure();
  }
}

enum DataSource {
  success(
    200,
    'Success',
  ), // success with data

  noContent(
    201,
    'Success but no data!',
  ), // success with no data (no content)

  badRequest(
    400,
    'Bad request, Try again later!',
  ), // failure, API rejected request

  unautorised(
    401,
    'User is unauthorised, Try again later!',
  ), // failure, user is not authorised

  forbidden(
    403,
    'Forbidden request, Try again later!',
  ), //  failure, API rejected request

  internalServerError(
    500,
    'Some thing went wrong, Try again later!',
  ), // failure, crash in server side

  connectTimeout(
    -1,
    'Time out error, Try again later!',
  ),

  notFound(
    -1,
    'Some thing went wrong, Try again later!',
  ),

  cancel(
    -2,
    'Request was cancelled, Try again later!',
  ),

  recieveTimeout(
    -3,
    'Time out error, Try again later!',
  ),

  sendTimeout(
    -4,
    'Time out error, Try again later!',
  ),

  cacheError(
    -5,
    'Cache error, Try again later!',
  ),

  noInternetConnection(
    -6,
    'Please check your internet connection!',
  ),

  defaultError(
    -7,
    'Please check your internet connection!',
  );

  const DataSource(this.code, this.message);
  final int code;
  final String message;
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return Failure(code, message);
      case DataSource.noContent:
        return Failure(code, message);
      case DataSource.badRequest:
        return Failure(code, message);
      case DataSource.unautorised:
        return Failure(code, message);
      case DataSource.forbidden:
        return Failure(code, message);
      case DataSource.internalServerError:
        return Failure(code, message);
      case DataSource.connectTimeout:
        return Failure(code, message);
      case DataSource.notFound:
        return Failure(code, message);
      case DataSource.cancel:
        return Failure(code, message);
      case DataSource.recieveTimeout:
        return Failure(code, message);
      case DataSource.sendTimeout:
        return Failure(code, message);
      case DataSource.cacheError:
        return Failure(code, message);
      case DataSource.noInternetConnection:
        return Failure(code, message);
      case DataSource.defaultError:
        return Failure(code, message);
    }
  }
}

class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}