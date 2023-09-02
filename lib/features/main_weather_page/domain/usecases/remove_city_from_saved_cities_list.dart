import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class RemoveCityFromSavedCitiesList {
  final WeatherRepository weatherRepository;

  RemoveCityFromSavedCitiesList(
    this.weatherRepository,
  );

  call(String cityToBeRemoved) async {
    return await weatherRepository
        .removeCityFromSavedCitiesList(cityToBeRemoved);
  }
}
