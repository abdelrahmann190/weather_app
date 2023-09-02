import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class CheckIfTheAppIsBeingOpenedForFirstTime {
  final WeatherRepository weatherRepository;

  CheckIfTheAppIsBeingOpenedForFirstTime({required this.weatherRepository});

  Future<bool> call() async {
    return await weatherRepository.checkIfTheAppIsBeingOpenedForFirstTime();
  }
}
