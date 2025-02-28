import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String get hm => DateFormat.Hm().format(this);
  String get friendly => DateFormat.yMMMd().format(this);

  String getDateRange(DateTime other) {
    if (day == other.day) {
      return '$hm - ${other.hm}';
    }
    return '$friendly - ${other.friendly}';
  }
}
