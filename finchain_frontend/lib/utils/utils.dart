class Utils {
  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      default:
        return "December";
    }
  }

  static String getDateString(int day, int month, int year) {
    return "${getMonthName(month)} $day, $year";
  }

  static String getTimeString(int hour, int minute) {
    String meridian;

    if (hour / 12 > 0) {
      meridian = "PM";
    } else {
      meridian = "AM";
    }

    hour = (hour % 12 == 0) ? 12 : hour % 12;

    return "$hour:${minute < 10 ? 0 : ""}$minute $meridian";
  }

  static String getDoubleString(double number) {
    String formattedNumber = number.toStringAsFixed(2);
    return "$formattedNumber BDT";
  }
}
