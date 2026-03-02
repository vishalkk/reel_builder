class StringUtils {
  static String capitalizeFirstLetter(String text) =>
      text.isNotEmpty ? '${text[0].toUpperCase()}${text.substring(1)}' : text;
}
