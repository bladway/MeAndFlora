import 'package:dio/dio.dart';
import 'package:dio_interceptor_plus/dio_interceptor_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:me_and_flora/core/domain/service/app_interceptor.dart';

import 'account_service.dart';
import 'auth_service.dart';
import 'camera_service.dart';
import 'history_service.dart';
import 'plant_service.dart';
import 'statistic_service.dart';
import 'track_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(
      Dio()..interceptors.addAll([AppInterceptors(), LoggingInterceptor()]),
      instanceName: 'dio');
  locator.registerLazySingleton<AuthService>(
      () => AuthService(wrapper: AppInterceptors()));
  //locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<AccountService>(() => AccountService());
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<HistoryService>(() => HistoryService());
  locator.registerLazySingleton<PlantService>(() => PlantService());
  locator.registerLazySingleton<StatisticService>(() => StatisticService());
  locator.registerLazySingleton<TrackService>(() => TrackService());
}
