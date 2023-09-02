// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:weather_app/features/main_weather_page/presentation/controllers/weather_bloc/app_controller_bloc.dart';
import 'package:weather_app/features/main_weather_page/presentation/widgets/city_selection_dialog.dart';
import 'package:weather_app/features/main_weather_page/presentation/widgets/show_saved_cities_dialog.dart';

import 'weather_data_dialog.dart';

class CustomDropDownButton extends StatefulWidget {
  final Color backgroundColor;
  final List savedCitiesList;
  final int dataIndex;
  final AppControllerBloc appControllerBloc;
  final BuildContext currentContext;
  const CustomDropDownButton({
    Key? key,
    required this.backgroundColor,
    required this.savedCitiesList,
    required this.dataIndex,
    required this.appControllerBloc,
    required this.currentContext,
  }) : super(key: key);

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownOverButton: true,
          customButton: Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              'assets/menu_list.png',
              scale: 6,
            ),
          ),
          customItemsHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
            ...List<double>.filled(MenuItems.secondItems.length, 48),
          ],
          items: [
            ...MenuItems.firstItems.map(
              (item) => DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              ),
            ),
            const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
            ...MenuItems.secondItems.map(
              (item) => DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              ),
            ),
          ],
          onChanged: (value) {
            MenuItems.onChanged(
              context: widget.currentContext,
              item: value as MenuItem,
              backgroundColor: widget.backgroundColor,
              savedCitiesList: widget.savedCitiesList,
              appControllerBloc: widget.appControllerBloc,
              dataIndex: widget.dataIndex,
            );
          },
          itemHeight: 48,
          itemPadding: const EdgeInsets.only(left: 16, right: 16),
          dropdownWidth: 200,
          dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: widget.backgroundColor,
          ),
          dropdownElevation: 8,
          offset: const Offset(0, -50),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [
    addNewCity,
    weatherDataType,
    savedCitiesList
  ];
  static const List<MenuItem> secondItems = [share];

  static const addNewCity = MenuItem(text: 'Add New City', icon: Icons.add_box);
  static const weatherDataType =
      MenuItem(text: 'Weather Data Type', icon: Icons.data_object);
  static const savedCitiesList =
      MenuItem(text: 'Saved Cities List', icon: Icons.location_city);
  static const share = MenuItem(text: 'Share', icon: Icons.share);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.black,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static onChanged({
    required BuildContext context,
    required MenuItem item,
    required Color backgroundColor,
    required List savedCitiesList,
    required AppControllerBloc appControllerBloc,
    required int dataIndex,
  }) {
    switch (item) {
      case MenuItems.addNewCity:
        // GoRouter.of(context).pushNamed(
        //   AppRoutes.citySelectionPageRoute,
        // );
        showDialog(
            context: context,
            builder: (context) {
              return CitySelectionDialog(
                backgroundColor: backgroundColor,
                savedCitiesList: savedCitiesList,
                appControllerBloc: appControllerBloc,
                currentContext: context,
              );
            });
        break;
      case MenuItems.weatherDataType:
        showDialog(
            context: context,
            builder: (context) {
              return WeatherDataDialog(
                backgroundColor: backgroundColor,
                appControllerBloc: appControllerBloc,
                dataIndex: dataIndex,
              );
            });
        break;
      case MenuItems.savedCitiesList:
        showDialog(
            context: context,
            builder: (context) {
              return ShowSavedCitiesDialog(
                backgroundColor: backgroundColor,
                savedCitiesList: savedCitiesList,
                appControllerBloc: appControllerBloc,
              );
            });
        break;
      case MenuItems.share:
        //TODO something
        break;
    }
  }
}
