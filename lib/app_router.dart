import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/core/services/app_routes.dart';
import 'package:weather_app/features/core/services/get_it_service_locator.dart';
import 'package:weather_app/features/main_weather_page/presentation/controllers/weather_bloc/app_controller_bloc.dart';
import 'package:weather_app/features/main_weather_page/presentation/pages/main_weather_page.dart';
import 'package:weather_app/features/main_weather_page/presentation/pages/splash_page.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashPageRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppControllerBloc(
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
            ),
            child: const SplashPage(),
          ),
        );
      case AppRoutes.mainWeatherPageRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppControllerBloc(
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
              getItServiceLocator(),
            ),
            child: const MainWeatherPage(),
          ),
        );
      // case AppRoutes.weatherForecastPageRoute:
      // return MaterialPageRoute(builder: builder)
    }
  }
}
