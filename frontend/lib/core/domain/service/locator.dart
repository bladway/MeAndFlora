import 'package:get_it/get_it.dart';
import 'package:me_and_flora/core/domain/service/history_service.dart';

import 'camera_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<HistoryService>(() => HistoryService());
}