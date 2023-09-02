import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class SetWeathreDataType {
  final WeatherRepository weatherRepository;

  SetWeathreDataType(this.weatherRepository);
  Future<bool> call(bool isDataInCelsious) async {
    return await weatherRepository.setWeatherDataType(isDataInCelsious);
  }
}
