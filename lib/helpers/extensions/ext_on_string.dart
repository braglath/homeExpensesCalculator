import 'package:homeexpensecalculator/helpers/encryption/encrypt.dart';
import 'package:homeexpensecalculator/helpers/functions/random_4_string.dart';

extension ConversionOnString on String? {
  DateTime get toDateTime => DateTime.parse(this!);
  int get toInt => int.parse(this!);
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  String get encrypt => Encryption.encryptString(this ?? '');
  String get random4String => Random4String.generate(this ?? '');
}
