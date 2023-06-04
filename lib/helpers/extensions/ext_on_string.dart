extension ConversionOnString on String? {
  DateTime get toDateTime => DateTime.parse(this!);
  int get toInt => int.parse(this!);
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
