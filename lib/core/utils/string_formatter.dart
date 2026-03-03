import 'dart:io';

import 'package:loggy/loggy.dart';

class StringFormatter {
  static String extractImageUri(String inputString) {
    if (inputString == " " || inputString == "null") {
      throw Exception("Image Uri is null or empty");
    }
    if (Platform.isAndroid) {
      final regExp = RegExp(r'imageUri=(.*?\.jpg)');
      final match = regExp.firstMatch(inputString);
      return match?.group(1) ?? '';
    } else {
      String filePath = inputString.replaceAll("[", "").replaceAll("]", "");
      List<String> paths = filePath.split(", ");
      logDebug("Formatted file path: $filePath");

      return paths.isNotEmpty ? paths.first : "";
    }
  }
}
