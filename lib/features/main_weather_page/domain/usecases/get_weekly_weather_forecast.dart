import 'package:dartz/dartz.dart';
import 'package:weather_app/features/core/domain/usecases/usecase.dart';
import 'package:weather_app/features/core/error/failures.dart';
import 'package:weather_app/features/main_weather_page/domain/entities/weekly_forecast.dart';
import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class GetWeeklyWeatherForecast
    implements UseCase<List<WeeklyForecastEntity>, int> {
  final WeatherRepository weatherRepository;

  GetWeeklyWeatherForecast({
    required this.weatherRepository,
  });
  @override
  Future<Either<Failure, List<WeeklyForecastEntity>>> call(
      int currentCityIndex) async {
    return await weatherRepository.getWeeklyWeatherForecast(currentCityIndex);
  }
}
