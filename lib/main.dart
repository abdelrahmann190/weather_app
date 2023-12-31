// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:weather_app/app_router.dart';

import 'package:weather_app/features/core/services/get_it_service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.initServiceLocator();

  runApp(
    WeatherApp(
      appRouter: getItServiceLocator(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  AppRouter appRouter;
  WeatherApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
