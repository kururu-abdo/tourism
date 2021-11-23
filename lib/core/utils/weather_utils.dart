import 'package:intl/intl.dart';

const icon_prefix = 'https://openweathermap.org/img/wn';
const icon_suffix = '@2x.png';

String getFormattedDate(int date, String format) =>
    DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(date * 1000));
