import "package:flutter_availability/src/config/availability_translations.dart";

/// Class that holds all options for the availability userstory
class AvailabilityOptions {
  /// AvailabilityOptions constructor where everything is optional.
  const AvailabilityOptions({
    this.translations = const AvailabilityTranslations.empty(),
  });

  /// The translations for the availability userstory
  final AvailabilityTranslations translations;
}
