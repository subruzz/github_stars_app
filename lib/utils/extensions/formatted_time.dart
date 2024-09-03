extension DateFormatting on DateTime {
  /// Converts the [DateTime] instance to a string in the format 'yyyy-MM-dd'.
  String toFormattedString() {
    final year = this.year.toString().padLeft(4, '0');
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
