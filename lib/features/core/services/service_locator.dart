import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/app_router.dart';
import 'package:weather_app/features/core/network/network_info.dart';
import 'package:weather_app/features/core/services/get_current_city.dart';
import 'package:weather_app/features/main_weather_page/data/data_source/weather_local_data_source.dart';
import 'package:weather_app/features/main_weather_page/data/data_source/weather_remote_data_source.dart';
import 'package:weather_app/features/main_weather_page/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/add_city_name_from_city_selection_list_to_saved_cities_list.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/add_current_city_to_cities_list.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/cache_city_name.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/check_if_data_in_celsious.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/check_if_the_app_is_being_opened_for_first_time.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/get_saved_cities_list.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/get_weekly_weather_forecast.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/remove_city_from_saved_cities_list.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/set_weather_data_type.dart';
import 'package:weather_app/features/main_weather_page/presentation/controllers/weather_bloc/app_controller_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

class ServiceLocator {
  static Future<void> initServiceLocator() async {
    //Router
    serviceLocator.registerLazySingleton<AppRouter>(
      () => AppRouter(),
    ); //Data Source
    serviceLocator.registerLazySingleton<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(
        weatherLocalDataSource: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<WeatherLocalDataSource>(
      () => WeatherLocalDataSourceImpl(
        sharedPreferences: serviceLocator(),
      ),
    );

    //Repositories
    serviceLocator.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(
        weatherRemoteDataSource: serviceLocator(),
        weatherLocalDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
        currentCityName: serviceLocator(),
      ),
    );
    //Use Cases
    serviceLocator.registerLazySingleton(
      () => GetCurrentWeather(
        weatherRepository: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => GetWeeklyWeatherForecast(
        weatherRepository: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => AddCurrentCityToCitiesList(
        weatherRepository: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => CurrentCityName(),
    );

    serviceLocator.registerLazySingleton(
      () => CacheCityName(
        weatherRepository: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => CheckIfTheAppIsBeingOpenedForFirstTime(
        weatherRepository: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => GetSavedCitiesList(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => AddCityNameFromCitySelectionListToSavedCitiesList(
        weatherRepository: serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => RemoveCityFromSavedCitiesList(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => SetWeathreDataType(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton(
      () => CheckIfDataInCelsious(
        weatherRepository: serviceLocator(),
      ),
    );
    //Bloc
    serviceLocator.registerFactory(
      () => AppControllerBloc(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );

    //Core
    serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        connectionChecker: serviceLocator(),
      ),
    );

    //External
    final sharedPreferences = await SharedPreferences.getInstance();
    serviceLocator.registerLazySingleton(
      () => sharedPreferences,
    );
    serviceLocator.registerLazySingleton(
      () => InternetConnectionChecker(),
    );
  }
}
