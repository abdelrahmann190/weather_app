// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:weather_app/features/core/utils/date_formatter.dart';
import 'package:weather_app/features/main_weather_page/domain/entities/weekly_forecast.dart';

class WeatehrForecastPage extends StatefulWidget {
  final Color backgroundColor;
  final List<WeeklyForecastEntity> weeklyForeCastList;
  final int currentCardIndex;
  final bool isDataInC;
  const WeatehrForecastPage({
    Key? key,
    required this.backgroundColor,
    required this.weeklyForeCastList,
    required this.currentCardIndex,
    required this.isDataInC,
  }) : super(key: key);

  @override
  State<WeatehrForecastPage> createState() => _WeatehrForecastPageState();
}

class _WeatehrForecastPageState extends State<WeatehrForecastPage> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      Future.delayed(const Duration(microseconds: 100))
          .then((value) => pageController.jumpToPage(widget.currentCardIndex));
    }
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: PageView.builder(
        controller: pageController,
        itemBuilder: (context, index) {
          final String currentDate = DateFormatter.formatWeeklyForecastPageDate(
            widget.weeklyForeCastList[index].date,
          );
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                              ),
                            ),
                            Text(
                              "Forecast - $currentDate",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1.1,
                        ),
                      ],
                    ),
                  ),
                  const Gap(50),
                  weatherRow(
                      label: "Condition:",
                      text: widget.weeklyForeCastList[index].condition),
                  weatherRow(
                      label: "Condition:",
                      text: widget.weeklyForeCastList[index].condition),
                  weatherRow(
                      label: "Average Humidity:",
                      text:
                          "${widget.weeklyForeCastList[index].avgHumidity.toString()}%"),
                  weatherRow(
                      label: "Average Temperature:",
                      text:
                          "${widget.isDataInC ? widget.weeklyForeCastList[index].avgTempC : widget.weeklyForeCastList[index].avgTempF} ${widget.isDataInC ? "°C" : "°F"}"),
                  weatherRow(
                      label: "Maximum Temperature:",
                      text:
                          "${widget.isDataInC ? widget.weeklyForeCastList[index].maxTempC : widget.weeklyForeCastList[index].maxTempF} ${widget.isDataInC ? "°C" : "°F"}"),
                  weatherRow(
                      label: "Minimum Temperature:",
                      text:
                          "${widget.isDataInC ? widget.weeklyForeCastList[index].minTempC : widget.weeklyForeCastList[index].minTempF} ${widget.isDataInC ? "°C" : "°F"}"),
                  weatherRow(
                    label: "Maximum Wind Speed:",
                    text:
                        "${widget.isDataInC ? widget.weeklyForeCastList[index].maxWindKPH : widget.weeklyForeCastList[index].maxWindMPH} ${widget.isDataInC ? "Km/h" : "Mi/h"}",
                  )
                ],
              ),
            ),
          );
        },
        itemCount: widget.weeklyForeCastList.length,
      ),
    );
  }

  Widget weatherRow({required String label, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Gap(15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
