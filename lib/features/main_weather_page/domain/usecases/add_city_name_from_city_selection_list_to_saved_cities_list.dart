import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class AddCityNameFromCitySelectionListToSavedCitiesList {
  final WeatherRepository weatherRepository;

  AddCityNameFromCitySelectionListToSavedCitiesList(
      {required this.weatherRepository});
  Future<void> call(String cityName) async {
    return await weatherRepository
        .addCityNameFromCitySelectionListToSavedCitiesList(cityName);
  }
}
