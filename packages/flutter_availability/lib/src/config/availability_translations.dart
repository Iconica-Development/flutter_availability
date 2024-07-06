// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";

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
    required this.templateSelectionLabel,
    required this.overviewScreenTitle,
    required this.createTemplateButton,
    required this.templateScreenTitle,
    required this.dayTemplates,
    required this.weekTemplates,
    required this.createDayTemplate,
    required this.createWeekTemplate,
    required this.monthYearFormatter,
    required this.weekDayAbbreviatedFormatter,
  });

  /// AvailabilityTranslations constructor where everything is optional.
  /// This provides default english values for the availability userstory.
  const AvailabilityTranslations.empty({
    this.appbarTitle = "Availability",
    this.editAvailabilityButton = "Edit availability",
    this.templateLegendTitle = "Templates",
    this.templateSelectionLabel = "Selected day(s)",
    this.createTemplateButton = "Create a new template",
    this.overviewScreenTitle = "Availability",
    this.templateScreenTitle = "Templates",
    this.dayTemplates = "Day templates",
    this.weekTemplates = "Week templates",
    this.createDayTemplate = "Create day template",
    this.createWeekTemplate = "Create week template",
    this.monthYearFormatter = _defaultMonthYearFormatter,
    this.weekDayAbbreviatedFormatter = _defaultWeekDayAbbreviatedFormatter,
  });

  /// The title shown above the calendar
  final String appbarTitle;

  /// The text shown on the button to edit availabilities for a range
  final String editAvailabilityButton;

  /// The title for the legend template section on the overview screen
  final String templateLegendTitle;

  /// The text for the selected days in the template legend
  final String templateSelectionLabel;

  /// The title on the overview screen
  final String overviewScreenTitle;

  /// The label on the button to go to the template screen
  final String createTemplateButton;

  /// The title on the template screen
  final String templateScreenTitle;

  /// The title for the day templates section on the template screen
  final String dayTemplates;

  /// The title for the week templates section on the template screen
  final String weekTemplates;

  /// The label for the button to create a new day template
  final String createDayTemplate;

  /// The label for the button to create a new week template
  final String createWeekTemplate;

  /// Gets the month and year formatted as a string
  ///
  /// The default implementation is `MonthName Year` in english
  final String Function(BuildContext, DateTime) monthYearFormatter;

  /// Gets the abbreviated name of a weekday
  ///
  /// The default implementation is the first 2 letters of
  /// the weekday in english
  final String Function(BuildContext, DateTime) weekDayAbbreviatedFormatter;
}

String _defaultWeekDayAbbreviatedFormatter(
  BuildContext context,
  DateTime date,
) =>
    _getWeekDayAbbreviation(date.weekday);

String _defaultMonthYearFormatter(BuildContext context, DateTime date) =>
    "${_getMonthName(date.month)} ${date.year}";

String _getWeekDayAbbreviation(int weekday) => switch (weekday) {
      1 => "Mo",
      2 => "Tu",
      3 => "We",
      4 => "Th",
      5 => "Fr",
      6 => "Sa",
      7 => "Su",
      _ => "",
    };

String _getMonthName(int month) => switch (month) {
      1 => "January",
      2 => "February",
      3 => "March",
      4 => "April",
      5 => "May",
      6 => "June",
      7 => "July",
      8 => "August",
      9 => "September",
      10 => "October",
      11 => "November",
      12 => "December",
      _ => "",
    };
