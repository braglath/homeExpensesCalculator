import 'package:intl/intl.dart';

extension FormatDate on DateTime {
  String get formattedMonth => DateFormat('MM/yyyy').format(this);
}
