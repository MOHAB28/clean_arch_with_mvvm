import 'package:image_picker/image_picker.dart';

import '../domain/usecase/forget_password_usecase.dart';
import '../domain/usecase/get_home_data_usecase.dart';
import '../domain/usecase/register_usecase.dart';
import '../presentation/forget_password/viewmodel/forget_password_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../data/data_sources/remote_data_sources.dart';
import '../presentation/login/viewmodel/login_viewmodel.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network/networl_info.dart';
import '../data/repository_impl/repository_impl.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/login_usecase.dart';
import '../presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import '../presentation/register/viewmodel/register_viewmodel.dart';
import 'app_prefs.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  instance
      .registerLazySingleton<AppPrefrences>(() => AppPrefrences(instance()));

  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewmodel>(() => LoginViewmodel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<GetHomeDataUsecase>()) {
    instance.registerFactory<GetHomeDataUsecase>(
        () => GetHomeDataUsecase(instance()));
    instance.registerFactory<HomeViewmodel>(
        () => HomeViewmodel(instance()));
  }
}