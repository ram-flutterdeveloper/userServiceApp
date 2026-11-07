import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Formats a [DateTime] to "dd MMM yyyy" e.g. "15 Mar 2025".
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Formats a [DateTime] to "hh:mm a" e.g. "10:30 AM".
  static String formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('hh:mm a').format(date);
  }

  /// Formats a [DateTime] to "dd MMM yyyy, hh:mm a" e.g. "15 Mar 2025, 10:30 AM".
  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  /// Returns a relative time string like "Just now", "5 min ago",
  /// "2 hours ago", "3 days ago", or falls back to [formatDate].
  static String formatRelative(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return '$m ${m == 1 ? 'min' : 'mins'} ago';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return '$d ${d == 1 ? 'day' : 'days'} ago';
    } else {
      return formatDate(date);
    }
  }

  /// Formats a booking date to "EEE, dd MMM yyyy" e.g. "Sat, 15 Mar 2025".
  static String formatBookingDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  /// Formats a review date to "MMM yyyy" e.g. "Mar 2025".
  static String formatReviewDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM yyyy').format(date);
  }
}
