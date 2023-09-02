import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class GetSavedCitiesList {
  final WeatherRepository _weatherRepository;

  GetSavedCitiesList(
    this._weatherRepository,
  );
  Future<List<String>> call() async {
    return await _weatherRepository.getSavedCitiesList();
  }
}
