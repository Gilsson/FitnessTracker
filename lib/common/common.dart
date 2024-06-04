import 'package:intl/intl.dart';

String getTime(int value, {String formatStr = "hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(
      DateTime.fromMillisecondsSinceEpoch(value * 60 * 1000, isUtc: true));
}

String getStringDateToOtherFormate(String dateStr,
    {String inputFormatStr = "dd/MM/yyyy hh:mm",
    String outFormatStr = "hh:mm aa"}) {
  var format = DateFormat(outFormatStr);
  return format.format(stringToDate(dateStr, formatStr: inputFormatStr));
}

DateTime stringToDate(String dateStr, {String formatStr = "hh:mm aa"}) {
  var format = DateFormat(formatStr);
  return format.parse(dateStr);
}

DateTime dateToStartDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String dateToString(DateTime date, {String formatStr = "dd/MM/yyyy hh:mm a"}) {
  var format = DateFormat(formatStr);
  return format.format(date);
}

String formatTo12Hour(DateTime dateTime) {
  final DateFormat formatter =
      DateFormat.jm(); // 'jm' is the pattern for 12-hour format with AM/PM
  return formatter.format(dateTime);
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

String getDayTitle(String dateStr, {String formatStr = "dd/MM/yyyy"}) {
  var date = DateTime.parse(dateStr);
//   var date = stringToDate(dateStr, formatStr: formatStr);

  if (calculateDifference(date) == 0) {
    return "Today";
  } else if (calculateDifference(date) == 1) {
    return "Tomorrow";
  } else if (calculateDifference(date) == -1) {
    return "Yesterday";
  } else {
    var outFormat = DateFormat("E");
    return outFormat.format(date);
  }
}

extension DateHelpers on DateTime {
  bool get isToday {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == 0;
  }

  bool get isYesterday {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == -1;
  }

  bool get isTomorrow {
    return DateTime(year, month, day).difference(DateTime.now()).inDays == 1;
  }
}
