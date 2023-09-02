// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:weather_app/features/core/services/app_routes.dart';
import 'package:weather_app/features/main_weather_page/presentation/controllers/weather_bloc/app_controller_bloc.dart';

class WeatherDataDialog extends StatefulWidget {
  final Color backgroundColor;
  final AppControllerBloc appControllerBloc;
  int dataIndex;

  WeatherDataDialog({
    Key? key,
    required this.backgroundColor,
    required this.appControllerBloc,
    required this.dataIndex,
  }) : super(key: key);

  @override
  State<WeatherDataDialog> createState() => _WeatherDataDialogState();
}

class _WeatherDataDialogState extends State<WeatherDataDialog> {
  final List labelsTextList = [
    "Show Weather Data in Celsious",
    "Show Weather Data in Fahrenheit",
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      backgroundColor: widget.backgroundColor,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 230,
        child: Column(
          children: [
            Column(
              children: List.generate(
                2,
                (index) => buildCityCard(
                  index,
                  labelsTextList[index],
                ),
              ),
            ),
            buildActionsRow(context),
          ],
        ),
      ),
    );
  }

  Row buildActionsRow(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              if (widget.dataIndex == 0) {
                widget.appControllerBloc.add(
                  const SetWeatherDataTypeEvent(isDataInC: true),
                );
                Future.delayed(
                  const Duration(milliseconds: 50),
                ).then(
                  (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.mainWeatherPageRoute,
                    (Route<dynamic> route) => false,
                  ),
                );
              } else if (widget.dataIndex == 1) {
                widget.appControllerBloc.add(
                  const SetWeatherDataTypeEvent(isDataInC: false),
                );
                Future.delayed(
                  const Duration(milliseconds: 50),
                ).then(
                  (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.mainWeatherPageRoute,
                    (Route<dynamic> route) => false,
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white30,
              ),
              child: const Center(
                child: Text(
                  "Set Data",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black,
              ),
              child: const Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCityCard(int index, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        highlightColor: widget.backgroundColor.withAlpha(10),
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          setState(() {
            widget.dataIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.dataIndex == index ? Colors.white10 : Colors.black12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                labelText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
