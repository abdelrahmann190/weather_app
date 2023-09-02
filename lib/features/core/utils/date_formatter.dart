import 'package:intl/intl.dart';

class DateFormatter {
  static bool checkIfCachedHourIsTheSameAsCurrentHour(String dateToBeChecked) {
    final String currentHour = DateFormat('DDHH').format(
      DateTime.now(),
    );
    final hourToBeChecked = DateFormat('DDHH').format(
      DateTime.parse(dateToBeChecked),
    );

    if (currentHour == hourToBeChecked) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkIfCachedDayIsTheSameAsCurrentDay(String dateToBeCached) {
    final String currentDay = DateFormat('D').format(
      DateTime.now(),
    );
    final dayToBeChecked = DateFormat('D').format(
      DateTime.parse(dateToBeCached),
    );
    if (currentDay == dayToBeChecked) {
      return true;
    } else {
      return false;
    }
  }

  static String formatWeeklyForecastDate(String date) {
    return DateFormat('d MMM').format(
      DateTime.parse(date),
    );
  }

  static String formatCurrentWeatherDate(String date) {
    return "${DateFormat('EEEE, d MMMM - ').format(DateTime.parse(date))}${DateFormat('j').format(DateTime.parse(date))}";
  }

  static String formatWeeklyForecastPageDate(String date) {
    return DateFormat('EEEE, d MMMM').format(DateTime.parse(date));
  }
}
