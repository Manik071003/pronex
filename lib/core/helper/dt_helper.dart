import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getFormattedTimeFor({required Duration duration}) {
    if (duration.inHours >= 1) return formatByHours(duration);
    if (duration.inMinutes >= 1) return formatByMinutes(duration);

    return formatBySeconds(duration);
  }

  static String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  static String formatBySeconds(Duration duration) =>
      twoDigits(duration.inSeconds.remainder(60));

  static String formatByMinutes(Duration duration) {
    var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return '$twoDigitMinutes:${formatBySeconds(duration)}';
  }

  static String formatByHours(Duration duration) {
    return '${twoDigits(duration.inHours)}:${formatByMinutes(duration)}';
  }

  static String getFormatDateTime(String dateTime) {
    DateTime dateTime1 = DateFormat('yyyy-MM-ddThh:mm:ss').parse(dateTime);
    var outputFormat = DateFormat('MMM dd yyyy hh:mma').format(dateTime1);
    return outputFormat.toString();
  }
}
