import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:intl/intl.dart';

class DateService {
  static final DateFormat _isoFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  static final DateFormat _normalDateFormat = DateFormat('yyyy-MM-dd');

  static DateTime fromUtcFromISOString(String date) {
    if (date.contains('.')) {
      final noMillisDate = date.substring(0, date.indexOf('.'));
      return _isoFormat.parse(noMillisDate, true);
    }
    return _isoFormat.parse(date, true);
  }

  static String toNormalDate({DateTime? date}) {
    try {
      if (date != null) {
        return _normalDateFormat.format(date).toUpperCase();
      }
      return _normalDateFormat.format(DateTime.now()).toUpperCase();
    } catch (ex) {
      ScaffoldMessengerService.instance.displayError(ex.toString());
    }

    return '-';
  }
}
