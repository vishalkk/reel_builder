import 'package:intl/intl.dart';

class DateFormatter {
  /// Converts API date string (yyyy-MM-dd) → UI format (MM/yyyy)
  static String? formatForUI(String? apiDate) {
    if (apiDate == null || apiDate.isEmpty) return null;
    try {
      final date = DateTime.parse(apiDate);
      return DateFormat("MM/yyyy").format(date);
    } catch (e) {
      return apiDate; // fallback in case of invalid format
    }
  }

  /// Converts UI date (MM/yyyy) → API format (yyyy-MM-dd)
  static String? formatForApi(String? uiDate) {
    if (uiDate == null || uiDate.isEmpty) return null;
    try {
      final date = DateFormat("MM/yyyy").parse(uiDate);
      // Always take 1st day of month since API expects yyyy-MM-dd
      return DateFormat("yyyy-MM-dd")
          .format(DateTime(date.year, date.month, 1));
    } catch (e) {
      return uiDate; // fallback
    }
  }

  /// Converts DateTime → API format (yyyy-MM-dd)
  static String formatDateTimeForApi(DateTime? date) {
    if (date == null) return "";
    return DateFormat("yyyy-MM-dd").format(date);
  }
}
