import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Log extends Logger {
  static final Log _instance = Log._internal();
  factory Log() => _instance;

  Log._internal() {
    var dateTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toString());
    var dateLocal = dateTime.toLocal();
    this.i("APP STARTUP " + dateLocal.toString());
  }
}
