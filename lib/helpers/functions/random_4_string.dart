import 'dart:math';

class Random4String {
  Random4String._internal();
  factory Random4String() => _singleton;
  static final Random4String _singleton = Random4String._internal();

  static String generate(String text) {
    final Random random = Random();
    final int randomIndex = random.nextInt(text.length - 3);
    final String randomString = text
        .substring(randomIndex, randomIndex + 4)
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '0');
    return randomString.toUpperCase();
  }
}
