// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weather_app/features/core/services/app_routes.dart';
import 'package:weather_app/features/core/utils/app_strings.dart';

import 'package:weather_app/features/main_weather_page/presentation/controllers/weather_bloc/app_controller_bloc.dart';

class ShowSavedCitiesDialog extends StatefulWidget {
  List savedCitiesList;
  final Color backgroundColor;
  final AppControllerBloc appControllerBloc;
  ShowSavedCitiesDialog({
    Key? key,
    required this.savedCitiesList,
    required this.backgroundColor,
    required this.appControllerBloc,
  }) : super(key: key);

  @override
  State<ShowSavedCitiesDialog> createState() => _ShowSavedCitiesDialogState();
}

class _ShowSavedCitiesDialogState extends State<ShowSavedCitiesDialog> {
  int? selectedCityIndex;
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
        constraints: const BoxConstraints(maxHeight: 546),
        padding: const EdgeInsets.all(15),
        height: widget.savedCitiesList.length * 68 + 70,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.savedCitiesList.length,
                itemBuilder: (context, index) {
                  return buildCityCard(index);
                },
              ),
            ),
            buildActionsRow(context),
          ],
        ),
      ),
    );
  }

  Row buildActionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (selectedCityIndex == null) {
            } else {
              if (selectedCityIndex == 0) {
              } else {
                widget.appControllerBloc.add(
                  RemoveCityFromSavedCitiesListEvent(
                    cityToBeRemoved: widget.savedCitiesList[selectedCityIndex!],
                  ),
                );
                widget.appControllerBloc.add(
                  const GetCurrentWeatherEvent(currentCityIndex: 0),
                );
                Future.delayed(
                  const Duration(
                    milliseconds: 50,
                  ),
                ).then(
                  (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.mainWeatherPageRoute,
                    (Route<dynamic> route) => false,
                  ),
                );
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.red,
            ),
            child: const Text(
              AppStrings.deleteSelectedCity,
              style: TextStyle(
                fontWeight: FontWeight.bold,
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

  Widget buildCityCard(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        highlightColor: widget.backgroundColor.withAlpha(10),
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          setState(() {
            selectedCityIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          padding: const EdgeInsets.all(
            15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: selectedCityIndex == index ? Colors.white10 : Colors.black12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.savedCitiesList[index],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
