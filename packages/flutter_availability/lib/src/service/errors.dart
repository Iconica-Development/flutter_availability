/// A set of errors
enum AvailabilityError {
  /// Error identifier when checking break mismatch
  breakMismatchWithAvailability(
    "The break needs to be within the timeframe of the availability",
  );

  const AvailabilityError(this.description);

  /// A more verbose description of the error.
  final String description;
}
