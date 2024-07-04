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
    required this.appbarTitle,
    required this.editAvailabilityButton,
    required this.templateLegendTitle,
    required this.overviewScreenTitle,
    required this.createTemplateButton,
  });

  /// AvailabilityTranslations constructor where everything is optional.
  /// This provides default english values for the availability userstory.
  const AvailabilityTranslations.empty({
    this.appbarTitle = "Availability",
    this.editAvailabilityButton = "Edit availability",
    this.templateLegendTitle = "Templates",
    this.createTemplateButton = "Create a new template",
    this.overviewScreenTitle = "Availability",
  });

  /// The title shown above the calendar
  final String appbarTitle;

  /// The text shown on the button to edit availabilities for a range
  final String editAvailabilityButton;

  /// The title for the legend template section on the overview screen
  final String templateLegendTitle;

  /// The title on the overview screen
  final String overviewScreenTitle;

  /// The label on the button to go to the tempalte creation page
  final String createTemplateButton;
}
