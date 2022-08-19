import 'package:freezed_annotation/freezed_annotation.dart';
part 'freezed_data_classes.freezed.dart';

@freezed
class LoginObject with _$LoginObject {
  factory LoginObject(String userName, String password) = _LoginObject;
}

@freezed
class RegisterObject with _$RegisterObject {
  factory RegisterObject({
    required String userName,
    required String countryMobileCode,
    required String mobileNumber,
    required String email,
    required String password,
    required String profilePicture,
  }) = _RegisterObject;
}
