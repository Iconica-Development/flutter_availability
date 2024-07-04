// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

/// Class that holds all translatable strings for the availability userstory
class AvailabilityTranslations {
  /// AvailabilityTranslations constructor where everything is required.
  /// If you want to have a default value, use the `empty` constructor.
  /// You can copyWith the values to override some default translations.
  /// It is recommended to use this constructor.
  const AvailabilityTranslations({
    required this.calendarTitle,
    required this.addAvailableDayButtonText,
    required this.availabilityOverviewTitle,
    required this.availabilityDate,
    required this.availabilityHours,
    required this.availabilityEmptyMessage,
    required this.availabilitySubmit,
    required this.availabilitySave,
  });

  /// AvailabilityTranslations constructor where everything is optional.
  /// This provides default english values for the availability userstory.
  const AvailabilityTranslations.empty({
    this.calendarTitle = "Availability",
    this.addAvailableDayButtonText = "Add availability",
    this.availabilityOverviewTitle = "Overview of your availabilities",
    this.availabilityDate = "Date",
    this.availabilityHours = "Hours",
    this.availabilityEmptyMessage =
        "No availabilities filled in for this month",
    this.availabilitySubmit = "Submit",
    this.availabilitySave = "Save",
  });

  /// The title shown above the calendar
  final String calendarTitle;

  /// The text shown on the button to add an available day
  final String addAvailableDayButtonText;

  /// The title for the overview of the availabilities
  final String availabilityOverviewTitle;

  /// The label for the date of an availability
  final String availabilityDate;

  /// The label for the hours of an availability
  final String availabilityHours;

  /// The text shown when there are no availabilities filled in for a month
  final String availabilityEmptyMessage;

  /// The text shown on the button to submit the availabilities
  final String availabilitySubmit;

  /// The text shown on the button to save a single availability
  final String availabilitySave;

  /// Method to update the translations with new values
  AvailabilityTranslations copyWith({
    String? calendarTitle,
    String? addAvailableDayButtonText,
    String? availabilityOverviewTitle,
    String? availabilityDate,
    String? availabilityHours,
    String? availabilityEmptyMessage,
    String? availabilitySubmit,
    String? availabilitySave,
  }) =>
      AvailabilityTranslations(
        calendarTitle: calendarTitle ?? this.calendarTitle,
        addAvailableDayButtonText:
            addAvailableDayButtonText ?? this.addAvailableDayButtonText,
        availabilityOverviewTitle:
            availabilityOverviewTitle ?? this.availabilityOverviewTitle,
        availabilityDate: availabilityDate ?? this.availabilityDate,
        availabilityHours: availabilityHours ?? this.availabilityHours,
        availabilityEmptyMessage:
            availabilityEmptyMessage ?? this.availabilityEmptyMessage,
        availabilitySubmit: availabilitySubmit ?? this.availabilitySubmit,
        availabilitySave: availabilitySave ?? this.availabilitySave,
      );
}
