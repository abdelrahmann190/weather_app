import 'package:dartz/dartz.dart';
import 'package:weather_app/features/core/domain/usecases/usecase.dart';
import 'package:weather_app/features/core/error/failures.dart';
import 'package:weather_app/features/main_weather_page/domain/repositories/weather_repository.dart';

class AddCurrentCityToCitiesList extends UseCase<String?, NoParams> {
  final WeatherRepository weatherRepository;

  AddCurrentCityToCitiesList({required this.weatherRepository});
  @override
  Future<Either<Failure, String?>> call(NoParams noParams) async {
    return await weatherRepository.addCurrentCityToSavedCitiesList();
  }
}
