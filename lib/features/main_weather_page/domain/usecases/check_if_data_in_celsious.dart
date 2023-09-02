// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class CheckIfDataInCelsious {
  WeatherRepository weatherRepository;
  CheckIfDataInCelsious({
    required this.weatherRepository,
  });
  Future<bool> call() async {
    return weatherRepository.checkIfDataInCelsious();
  }
}
