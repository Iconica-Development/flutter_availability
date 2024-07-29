import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";

/// method to return if 2 dates are at the same time of the day
/// ignoring the date
bool isAtSameTime(DateTime date1, DateTime date2) =>
    date1.hour == date2.hour && date1.minute == date2.minute;

/// extension to bridge between material and flutter agnostic dart package
extension DateRangeConversion on DateTimeRange {
  /// Creates a new [DateRange] given the internal [start] and [end] values.
  DateRange toAvailabilityDateRange() => DateRange(start: start, end: end);
}
