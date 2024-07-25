/// A set of errors
enum AvailabilityError {
  /// Error identifier for when a submitted break ends before the availability
  /// starts
  breakEndBeforeStart(
    "The break ends before the start of the break",
  ),

  /// Error identifier for when the submitted duration of a break is longer than
  /// the difference between the start and end time
  breakSubmittedDurationTooLong(
    "The submitted duration is longer than the difference between the start "
    "and end time",
  ),

  /// Error identifier for when the end of the day is before the start
  endBeforeStart("The end of the day is before the start"),

  /// Error identifier for when one of the submitted breaks starts before the
  /// availability
  templateBreakBeforeStart(
    "One of the submitted breaks starts before the start of the availability",
  ),

  /// Error identifier for when one of the submitted breaks ends after the
  /// availability
  templateBreakAfterEnd(
    "One of the submitted breaks ends after the end of the availability",
  );

  const AvailabilityError(this.description);

  /// A more verbose description of the error.
  final String description;
}
