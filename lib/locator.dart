import '../services/camera_service.dart';
import '../services/firestore_service.dart';
import '../services/real_time_db_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FireStoreService>(() => FireStoreService());
  locator.registerLazySingleton<CourtOrderService>(() => CourtOrderService());
}
