import 'package:get_it/get_it.dart';
import 'package:demo_project/services/auth_services.dart';
import 'package:demo_project/services/firestore_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => AuthServices());
  locator.registerLazySingleton(() => FirestoreService());
}