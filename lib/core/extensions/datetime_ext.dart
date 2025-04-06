import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String get hm => DateFormat.Hm().format(this);
  String get friendly => DateFormat.yMMMd().format(this);
  String get friendlyComplete => DateFormat.yMMMd().add_Hm().format(this);
  bool isSameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String getDateRange(DateTime other) {
    if (isSameDayAs(other)) {
      return '$hm - ${other.hm}';
    }
    return '$friendly - ${other.friendly}';
  }
}
