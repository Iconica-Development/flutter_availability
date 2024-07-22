/// Utility datetime functions for the availability data interface
extension DateUtils on DateTime {
  /// Gets the date without the time
  DateTime get date => DateTime(year, month, day);

  /// Returns true if the time of the date matches the time of the other date
  bool timeMatches(DateTime other) =>
      other.hour == hour && other.minute == minute;
}
