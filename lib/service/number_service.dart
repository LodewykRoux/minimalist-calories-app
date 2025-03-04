import 'package:intl/intl.dart';

class NumberService {
  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value.toDouble();
    }
  }

  static bool isInteger(num value) {
    return value is int || value == value.roundToDouble();
  }

  static String removeDecimalIfNeeded(num value) {
    var number = NumberFormat('#');

    return NumberService.isInteger(value)
        ? number.format(value.toInt())
        : number.format(value);
  }
}
