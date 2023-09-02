// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/features/core/domain/usecases/usecase.dart';

import 'package:weather_app/features/main_weather_page/domain/entities/current_weather.dart';
import 'package:weather_app/features/main_weather_page/domain/entities/weekly_forecast.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/add_city_name_from_city_selection_list_to_saved_cities_list.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/add_current_city_to_cities_list.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/cache_city_name.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/check_if_data_in_celsious.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/check_if_the_app_is_being_opened_for_first_time.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/get_saved_cities_list.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/get_weekly_weather_forecast.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/remove_city_from_saved_cities_list.dart';
import 'package:weather_app/features/main_weather_page/domain/usecases/set_weather_data_type.dart';

part 'app_controller_events.dart';
part 'app_controller_states.dart';

class AppControllerBloc extends Bloc<AppControllerEvent, AppControllerState> {
  final GetCurrentWeather _getCurrentWeatherUseCase;
  final GetWeeklyWeatherForecast _getWeeklyWeatherForecast;
  final AddCurrentCityToCitiesList _addCurrentCityToCitiesList;
  final CacheCityName _cacheCityName;
  final CheckIfTheAppIsBeingOpenedForFirstTime
      _checkIfTheAppIsBeingOpenedForFirstTime;
  final GetSavedCitiesList _getSavedCitiesList;
  final AddCityNameFromCitySelectionListToSavedCitiesList
      _addCityNameFromCitySelectionListToSavedCitiesList;
  final RemoveCityFromSavedCitiesList _removeCityFromSavedCitiesList;
  final SetWeathreDataType _setWeathreDataType;
  final CheckIfDataInCelsious _checkIfDataInCelsious;
  AppControllerBloc(
    this._getCurrentWeatherUseCase,
    this._getWeeklyWeatherForecast,
    this._addCurrentCityToCitiesList,
    this._cacheCityName,
    this._checkIfTheAppIsBeingOpenedForFirstTime,
    this._getSavedCitiesList,
    this._addCityNameFromCitySelectionListToSavedCitiesList,
    this._removeCityFromSavedCitiesList,
    this._setWeathreDataType,
    this._checkIfDataInCelsious,
  ) : super(WeatherInitial()) {
    on<GetCurrentWeatherEvent>(
      (event, emit) async {
        final List savedCitiesList = await _getSavedCitiesList();
        final bool isDataInC = await _checkIfDataInCelsious();
        emit(
          CurrentWeatherLoading(
            savedCitiesList: savedCitiesList,
            isDataInC: isDataInC,
          ),
        );
        final currentWeatherValue =
            await _getCurrentWeatherUseCase(event.currentCityIndex);
        currentWeatherValue.fold(
          (l) => emit(
            CurrentWeatherLoadingError(
              errormessage: l.message,
              savedCitiesList: savedCitiesList,
              isDataInC: isDataInC,
            ),
          ),
          (r) => emit(
            CurrentWeatherLoaded(
              currentWeather: r,
              savedCitiesList: savedCitiesList,
              isDataInC: isDataInC,
            ),
          ),
        );
      },
    );
    on<GetWeeklyWeatherForecastEvent>(
      (event, emit) async {
        final bool isDataInC = await _checkIfDataInCelsious();
        final citiesList = await _getSavedCitiesList();
        emit(WeeklyWeatherForecastLoading());
        final weeklyWeatherForecast = await _getWeeklyWeatherForecast(
          event.currentCityIndex,
        );
        weeklyWeatherForecast.fold(
          (l) => emit(
            WeeklyWeatherForecastLoadingError(
              message: l.message,
            ),
          ),
          (r) => emit(
            WeeklyWeatherForecastLoaded(
              weeklyForecastList: r,
              savedCitiesList: citiesList,
              isDataInC: isDataInC,
            ),
          ),
        );
      },
    );
    on<GetCurrentCityNameEvent>(
      (event, emit) async {
        final cityName = await _addCurrentCityToCitiesList(
          NoParams(),
        );
        final List savedCitiesList = await _getSavedCitiesList();
        cityName.fold(
          (l) => emit(
            CityNameError(),
          ),
          (r) {
            _cacheCityName(r!);
            return emit(
              CityNameLoaded(
                savedCitiesList: savedCitiesList,
              ),
            );
          },
        );
      },
    );
    on<CheckIfTheAppIsBeingOpenedForFirstTimeEvent>(
      (event, emit) async {
        final List savedCitiesList = await _getSavedCitiesList();
        bool isAppOpenedForTheFirstTime =
            await _checkIfTheAppIsBeingOpenedForFirstTime();
        if (isAppOpenedForTheFirstTime == false) {
          emit(
            CityNameLoaded(
              savedCitiesList: savedCitiesList,
            ),
          );
        }
      },
    );
    on<AddCityNameFromCitySelectionListToSavedCitiesListEvent>(
      (event, emit) async {
        final List savedCitiesList = await _getSavedCitiesList();
        final bool isDataInC = await _checkIfDataInCelsious();

        _addCityNameFromCitySelectionListToSavedCitiesList(
          event.selectedCityName,
        );

        emit(
          CurrentWeatherLoading(
            savedCitiesList: savedCitiesList,
            isDataInC: isDataInC,
          ),
        );
        final currentWeatherValue = await _getCurrentWeatherUseCase(0);
        currentWeatherValue.fold(
          (l) => emit(
            CurrentWeatherLoadingError(
              errormessage: l.message,
              savedCitiesList: savedCitiesList,
              isDataInC: isDataInC,
            ),
          ),
          (r) => emit(
            CurrentWeatherLoaded(
              currentWeather: r,
              savedCitiesList: savedCitiesList,
              isDataInC: isDataInC,
            ),
          ),
        );
      },
    );

    on<RemoveCityFromSavedCitiesListEvent>(
      (event, emit) async {
        _removeCityFromSavedCitiesList(
          event.cityToBeRemoved,
        );
        final List savedCitiesList = await _getSavedCitiesList();
        final bool isDataInC = await _checkIfDataInCelsious();

        emit(
          CurrentWeatherLoading(
            savedCitiesList: savedCitiesList,
            isDataInC: isDataInC,
          ),
        );
        final currentWeatherValue = await _getCurrentWeatherUseCase(0);
        currentWeatherValue.fold(
          (l) => emit(
            CurrentWeatherLoadingError(
              errormessage: l.message,
              savedCitiesList: savedCitiesList,
              isDataInC: isDataInC,
            ),
          ),
          (r) => emit(
            CurrentWeatherLoaded(
              currentWeather: r,
              savedCitiesList: savedCitiesList,
              isDataInC: isDataInC,
            ),
          ),
        );
      },
    );
    on<SetWeatherDataTypeEvent>(
      (event, emit) async {
        await _setWeathreDataType(
          event.isDataInC,
        );
        final List savedCitiesList = await _getSavedCitiesList();
        final bool isDataInC = await _checkIfDataInCelsious();

        emit(
          CurrentWeatherLoading(
            savedCitiesList: savedCitiesList,
            isDataInC: isDataInC,
          ),
        );
        final currentWeatherValue = await _getCurrentWeatherUseCase(0);
        currentWeatherValue.fold(
          (l) => emit(
            CurrentWeatherLoadingError(
              errormessage: l.message,
              savedCitiesList: savedCitiesList,
              isDataInC: isDataInC,
            ),
          ),
          (r) => emit(
            CurrentWeatherLoaded(
              currentWeather: r,
              savedCitiesList: savedCitiesList,
              isDataInC: isDataInC,
            ),
          ),
        );
      },
    );
  }
}
