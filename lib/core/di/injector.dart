import 'package:get_it/get_it.dart';
import '../../presentations/bottom_nav_bar/bottom_nav_bar_view_model.dart';
import '../../presentations/onboarding/onboarding_view_model.dart';
import '../../presentations/splash/splash_view_model.dart';
import '../repository/app_repository.dart';
import '../services/remote/network/api_impl.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  injector.registerLazySingleton(() => ApiImpl());
  injector.registerLazySingleton(() => AppRepository());
  injector.registerLazySingleton(() => SplashViewModel());
  injector.registerLazySingleton(() => OnboardingViewModel());
  injector.registerLazySingleton(() => BottomNavBarVM());

}
