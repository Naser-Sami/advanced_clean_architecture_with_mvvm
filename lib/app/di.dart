
import 'package:advanced_clean_architecture_with_mvvm/app/app_prefs.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/data_source/remote_data_source.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/app_api.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/dio_factory.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/network_info.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/repository/repository_impl.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/repository/repository.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/usecase/login_usecase.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {

  // .. app module, where we put all generic dependence

  // .. instance from SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // .. app preference instance
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance<SharedPreferences>()));
  
  // .. network instance
  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(InternetConnectionChecker()));

  // .. dio factory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance<AppPreferences>()));

  // .. app service client instance
  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // .. remote data source instance
  instance.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(instance<AppServiceClient>()));

  // .. repository instance
  instance.registerLazySingleton<Repository>(() => RepositoryImpl(instance<RemoteDataSource>(), instance<NetworkInfo>()));

}

 initLoginModule() {
  if(!GetIt.I.isRegistered<LoginUseCase>()) {
    // .. login use case instance
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance<Repository>()));

    // .. login view model instance
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance<LoginUseCase>()));
  }
}