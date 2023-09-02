import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:weather_app/features/core/utils/app_strings.dart';
import 'package:weather_app/features/core/utils/colors_list.dart';
import 'package:weather_app/features/core/utils/date_formatter.dart';
import 'package:weather_app/features/main_weather_page/presentation/controllers/weather_bloc/app_controller_bloc.dart';
import 'package:weather_app/features/main_weather_page/presentation/pages/weather_forecast_page.dart';
import 'package:weather_app/features/main_weather_page/presentation/widgets/drop_down_button.dart';
import 'package:weather_app/features/main_weather_page/presentation/widgets/weather_conditions_card.dart';
import 'package:weather_app/features/main_weather_page/presentation/widgets/weather_forecast_card.dart';

class MainWeatherPage extends StatefulWidget {
  const MainWeatherPage({super.key});

  @override
  State<MainWeatherPage> createState() => _MainWeatherPageState();
}

class _MainWeatherPageState extends State<MainWeatherPage> {
  int colorIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(
          milliseconds: 800,
        ),
        color: ColorsList.appColor[colorIndex],
        child: BlocBuilder<AppControllerBloc, AppControllerState>(
          buildWhen: (previous, current) {
            return current is CurrentWeatherState;
          },
          builder: (context, state) {
            if (state is CurrentWeatherState) {
              return handleCurrentWeatherState(state);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  PageView handleCurrentWeatherState(CurrentWeatherState state) {
    return PageView.builder(
      physics: const BouncingScrollPhysics(),
      onPageChanged: (value) async {
        setState(
          () {
            colorIndex = value;
          },
        );
        manageBlocFunctions(value);
      },
      itemCount: state.savedCitiesList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Expanded(
              flex: 4,
              child: buildCurrentWeatherItems(state),
            ),
            buildWeatehrforecastTextLine(),
            const Gap(20),
            buildWeatherForecastCards(),
          ],
        );
      },
    );
  }

  Widget buildCurrentWeatherItems(
    CurrentWeatherState state,
  ) {
    if (state is CurrentWeatherLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: ColorsList.appColor[colorIndex],
        ),
      );
    } else if (state is CurrentWeatherLoadingError) {
      return Center(
        child: Text(state.errormessage),
      );
    } else if (state is CurrentWeatherLoaded) {
      return buildMainWeatherPage(state, context);
    } else {
      return Container();
    }
  }

  Padding buildWeatehrforecastTextLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            AppStrings.weeklyForecast,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Icon(
            Icons.arrow_forward_outlined,
          )
        ],
      ),
    );
  }

  Expanded buildWeatherForecastCards() {
    return Expanded(
      child: BlocBuilder<AppControllerBloc, AppControllerState>(
        buildWhen: (previous, current) {
          return current is WeeklyWeatherForecastState;
        },
        builder: (context, state) {
          if (state is WeeklyWeatherForecastLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return WeatherForecastCard(
                  expectedWeatherDegree: state.isDataInC
                      ? state.weeklyForecastList[index].avgTempC.toString()
                      : state.weeklyForecastList[index].avgTempF.toString(),
                  weatherIcon: state.weeklyForecastList[index].icon,
                  date: state.weeklyForecastList[index].date,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeatehrForecastPage(
                          backgroundColor: ColorsList.appColor[colorIndex],
                          weeklyForeCastList: state.weeklyForecastList,
                          currentCardIndex: index,
                          isDataInC: state.isDataInC,
                        ),
                      ),
                    );
                  },
                );
              },
              itemCount: state.weeklyForecastList.length,
              scrollDirection: Axis.horizontal,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildMainWeatherPage(
    CurrentWeatherLoaded state,
    BuildContext context,
  ) {
    final List citiesList = state.savedCitiesList;
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 20,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomDropDownButton(
                  backgroundColor: ColorsList.appColor[colorIndex],
                  savedCitiesList: citiesList,
                  appControllerBloc:
                      BlocProvider.of<AppControllerBloc>(context),
                  currentContext: context,
                  dataIndex: state.isDataInC ? 0 : 1,
                ),
                const Gap(70),
                Text(
                  state.currentWeather.cityName.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const Gap(15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.black,
              ),
              child: Text(
                DateFormatter.formatCurrentWeatherDate(
                  state.currentWeather.lastUpdated,
                ),
                style: TextStyle(
                  color: ColorsList.appColor[colorIndex],
                  fontSize: 17,
                ),
              ),
            ),
            const Gap(15),
            Text(
              state.currentWeather.condition,
              style: const TextStyle(
                fontSize: 22,
              ),
            ),
            const Gap(10),
            Text(
              "${state.isDataInC ? state.currentWeather.tempC : state.currentWeather.tempF}°",
              style: const TextStyle(
                fontSize: 180,
              ),
            ),
            const Gap(10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.dailySummary,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      "Now it feels like +${state.isDataInC ? state.currentWeather.feelsLikeC : state.currentWeather.feelsLikeF}°\nThe temperature is felt in the range of +${state.isDataInC ? state.currentWeather.maxTempC : state.currentWeather.maxTempF}° to +${state.isDataInC ? state.currentWeather.minTempC : state.currentWeather.minTempF}°",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(20),
            WeatherConditionsCard(
              backgroundColor: ColorsList.appColor[colorIndex],
              currentWeather: state.currentWeather,
              isDataInC: state.isDataInC,
            ),
          ],
        ),
      ),
    );
  }

  void manageBlocFunctions(int currentCityIndex) {
    BlocProvider.of<AppControllerBloc>(context).add(
      GetCurrentWeatherEvent(currentCityIndex: currentCityIndex),
    );
    BlocProvider.of<AppControllerBloc>(context).add(
      GetWeeklyWeatherForecastEvent(currentCityIndex: currentCityIndex),
    );
  }

  @override
  void initState() {
    manageBlocFunctions(0);
    super.initState();
  }
}
