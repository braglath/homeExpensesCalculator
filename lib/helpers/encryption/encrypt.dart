import 'package:encrypt/encrypt.dart';

class Encryption {
  Encryption._internal();
  factory Encryption() => _singleton;
  static final Encryption _singleton = Encryption._internal();

  static String encryptString(String textToEncrypt) {
    final Key key = Key.fromLength(32);
    final IV iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(key));
    final Encrypted encrypted = encrypter.encrypt(textToEncrypt, iv: iv);
    return encrypted.base64;
  }
}
