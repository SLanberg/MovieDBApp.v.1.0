// Package imports:
import 'package:intl/intl.dart';

String formatDateWithSuffix(DateTime date) {
  String formattedDate = DateFormat('dd MMMM yyyy').format(date);
  String daySuffix = _getDaySuffix(date.day);

  return formattedDate.replaceFirst(
    RegExp(r'\b(\d+)\b'),
    '${date.day}$daySuffix',
  );
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }

  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
