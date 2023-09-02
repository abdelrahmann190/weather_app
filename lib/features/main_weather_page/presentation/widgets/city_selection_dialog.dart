// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weather_app/features/core/services/app_routes.dart';

import 'package:weather_app/features/main_weather_page/presentation/controllers/weather_bloc/app_controller_bloc.dart';

class CitySelectionDialog extends StatefulWidget {
  final Color backgroundColor;
  final List savedCitiesList;
  final AppControllerBloc appControllerBloc;
  final BuildContext currentContext;
  const CitySelectionDialog({
    Key? key,
    required this.backgroundColor,
    required this.savedCitiesList,
    required this.appControllerBloc,
    required this.currentContext,
  }) : super(key: key);

  @override
  State<CitySelectionDialog> createState() => _CitySelectionDialog();
}

class _CitySelectionDialog extends State<CitySelectionDialog> {
  /// Variables to store country state city data in onChanged method.
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Container(
        height: address.isEmpty ? 200 : 225,
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              ///Adding CSC Picker Widget in app
              CSCPicker(
                ///Enable disable state dropdown [OPTIONAL PARAMETER]
                showStates: true,

                /// Enable disable city drop down [OPTIONAL PARAMETER]
                showCities: true,

                ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                flagState: CountryFlag.DISABLE,
                // countryFilter: [CscCountry],
                ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                dropdownDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),

                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                disabledDropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),

                ///placeholders for dropdown search field
                countrySearchPlaceholder: "Country",
                stateSearchPlaceholder: "State",
                citySearchPlaceholder: "City",

                ///labels for dropdown
                countryDropdownLabel: "Country",
                stateDropdownLabel: "State",
                cityDropdownLabel: "City",

                ///Default Country
                //defaultCountry: CscCountry.India,

                ///Disable country dropdown (Note: use it with default country)
                //disableCountry: true,

                ///Country Filter [OPTIONAL PARAMETER]
                // countryFilter: [
                //   CscCountry.India,
                //   CscCountry.United_States,
                //   CscCountry.Canada
                // ],

                ///selected item style [OPTIONAL PARAMETER]
                selectedItemStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),

                ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                dropdownHeadingStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),

                ///DropdownDialog Item style [OPTIONAL PARAMETER]
                dropdownItemStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),

                ///Dialog box radius [OPTIONAL PARAMETER]
                dropdownDialogRadius: 30.0,

                ///Search bar radius [OPTIONAL PARAMETER]
                searchBarRadius: 30.0,

                ///triggers once country selected in dropdown
                onCountryChanged: (value) {
                  setState(() {
                    ///store value in country variable
                    countryValue = value;
                  });
                },

                ///triggers once state selected in dropdown
                onStateChanged: (value) {
                  setState(() {
                    ///store value in state variable
                    stateValue = value ?? "";
                  });
                },

                ///triggers once city selected in dropdown
                onCityChanged: (value) {
                  setState(() {
                    ///store value in city variable
                    cityValue = value ?? "";
                  });
                },
              ),
              const Gap(20),
              SizedBox(
                height: address.isEmpty ? 0 : 30,
                child: Text(
                  address,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      String cityName = '';
                      if (cityValue != "") {
                        cityName = cityValue;
                        widget.appControllerBloc.add(
                          AddCityNameFromCitySelectionListToSavedCitiesListEvent(
                              selectedCityName: "$countryValue - $cityName"),
                        );

                        Navigator.of(widget.currentContext)
                            .pushNamedAndRemoveUntil(
                          AppRoutes.mainWeatherPageRoute,
                          (Route<dynamic> route) => false,
                        );
                      } else if (stateValue != '') {
                        if (widget.savedCitiesList.contains(cityName)) {
                          setState(() {
                            address = "This city is already added";
                          });
                        } else {
                          widget.appControllerBloc.add(
                            AddCityNameFromCitySelectionListToSavedCitiesListEvent(
                              selectedCityName: "$countryValue - $stateValue",
                            ),
                          );
                          Navigator.of(widget.currentContext)
                              .pushNamedAndRemoveUntil(
                            AppRoutes.mainWeatherPageRoute,
                            (Route<dynamic> route) => false,
                          );
                        }
                      }
                      if (cityName.isEmpty) {
                        setState(
                          () {
                            address = "Please select a city first";
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white60,
                      ),
                      child: const Text(
                        "Add Selected City",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Gap(5),
                  Expanded(
                    child: GestureDetector(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
