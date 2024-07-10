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
    required this.availabilityWithoutTemplateLabel,
    required this.overviewScreenTitle,
    required this.createTemplateButton,
    required this.unavailableForDay,
    required this.unavailableForMultipleDays,
    required this.availabilityAddTemplateTitle,
    required this.availabilityTimeTitle,
    required this.availabilitiesTimeTitle,
    required this.templateScreenTitle,
    required this.dayTemplates,
    required this.weekTemplates,
    required this.createDayTemplate,
    required this.createWeekTemplate,
    required this.deleteTemplateButton,
    required this.dayTemplateTitle,
    required this.templateTitleHintText,
    required this.templateTitleLabel,
    required this.templateColorLabel,
    required this.time,
    required this.timeSeparator,
    required this.timeMinutes,
    required this.templateTimeLabel,
    required this.pauseSectionTitle,
    required this.pauseSectionOptional,
    required this.pauseDialogTitle,
    required this.pauseDialogDescription,
    required this.pauseDialogPeriodTitle,
    required this.pauseDialogPeriodDescription,
    required this.saveButton,
    required this.addButton,
    required this.timeFormatter,
    required this.dayMonthFormatter,
    required this.periodFormatter,
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
    this.availabilityWithoutTemplateLabel = "Availabilty without template",
    this.createTemplateButton = "Create a new template",
    this.unavailableForDay = "I am not available this day",
    this.unavailableForMultipleDays = "I am not available these days",
    this.availabilityAddTemplateTitle = "Add template to availability",
    this.availabilityTimeTitle = "Start and end time workday",
    this.availabilitiesTimeTitle = "Start and end time workdays",
    this.overviewScreenTitle = "Availability",
    this.templateScreenTitle = "Templates",
    this.dayTemplates = "Day templates",
    this.weekTemplates = "Week templates",
    this.createDayTemplate = "Create day template",
    this.createWeekTemplate = "Create week template",
    this.deleteTemplateButton = "Delete template",
    this.dayTemplateTitle = "Day template",
    this.templateTitleHintText = "What do you want to call this template?",
    this.templateTitleLabel = "Template Title",
    this.templateColorLabel = "Colorlabel",
    this.time = "Time",
    this.timeSeparator = "to",
    this.timeMinutes = "minutes",
    this.templateTimeLabel = "When are you available?",
    this.pauseSectionTitle = "Add a pause",
    this.pauseSectionOptional = "(Optional)",
    this.pauseDialogTitle = "Add a pause",
    this.pauseDialogDescription = "Add a pause to your availability. "
        "Choose how long you want to take a break",
    this.pauseDialogPeriodTitle = "Time slot",
    this.pauseDialogPeriodDescription =
        "Select between which times you want to take a break",
    this.saveButton = "Save",
    this.addButton = "Add",
    this.dayMonthFormatter = _defaultDayMonthFormatter,
    this.periodFormatter = _defaultPeriodFormatter,
    this.monthYearFormatter = _defaultMonthYearFormatter,
    this.weekDayAbbreviatedFormatter = _defaultWeekDayAbbreviatedFormatter,
    this.timeFormatter = _defaultTimeFormatter,
  });

  /// The title shown above the calendar
  final String appbarTitle;

  /// The text shown on the button to edit availabilities for a range
  final String editAvailabilityButton;

  /// The title for the legend template section on the overview screen
  final String templateLegendTitle;

  /// The text for the selected days in the template legend
  final String templateSelectionLabel;

  /// The label for the availabilities without a template in the template legend
  final String availabilityWithoutTemplateLabel;

  /// The title on the overview screen
  final String overviewScreenTitle;

  /// The label on the button to go to the template screen
  final String createTemplateButton;

  /// The text shown to clear the availability for a day
  final String unavailableForDay;

  /// The text shown to clear the availability for multiple days
  final String unavailableForMultipleDays;

  /// The title on the template selection section for adding availabilities
  final String availabilityAddTemplateTitle;

  /// The title on the time selection section for adding a single availability
  final String availabilityTimeTitle;

  /// The title on the time selection section for adding multiple availabilities
  final String availabilitiesTimeTitle;

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

  /// The label on the button to delete a template
  final String deleteTemplateButton;

  /// The title for the day template edit screen
  final String dayTemplateTitle;

  /// The hint text for the template title input field
  final String templateTitleHintText;

  /// The label for the template title input field
  final String templateTitleLabel;

  /// The title above the color selection for templates
  final String templateColorLabel;

  /// The title for time sections
  final String time;

  /// The text between start and end time
  final String timeSeparator;

  /// The text used for minutes
  final String timeMinutes;

  /// The label for the template time input
  final String templateTimeLabel;

  /// The title for pause configuration sections
  final String pauseSectionTitle;

  /// The label for optional indication on pause sections
  final String pauseSectionOptional;

  /// The title for the pause dialog
  final String pauseDialogTitle;

  /// The description for the pause dialog displayed below the title
  final String pauseDialogDescription;

  /// The title for the section in the pause dialog where you select the period
  final String pauseDialogPeriodTitle;

  /// The description for the section in the pause dialog where you select
  /// the period
  final String pauseDialogPeriodDescription;

  /// The text on the save button
  final String saveButton;

  /// The text on the add button
  final String addButton;

  /// Gets the day and month formatted as a string
  ///
  /// The default implementation is `Dayname day monthname` in english
  final String Function(BuildContext, DateTime) dayMonthFormatter;

  /// Gets the period between two dates formatted as a string
  ///
  /// The default implementation is `day monthname to day monthname` in english
  final String Function(BuildContext, DateTimeRange) periodFormatter;

  /// Gets the month and year formatted as a string
  ///
  /// The default implementation is `MonthName Year` in english
  final String Function(BuildContext, DateTime) monthYearFormatter;

  /// Gets the abbreviated name of a weekday
  ///
  /// The default implementation is the first 2 letters of
  /// the weekday in english
  final String Function(BuildContext, DateTime) weekDayAbbreviatedFormatter;

  /// Get the time formatted as a string
  ///
  /// The default implementation is `HH:mm`
  final String Function(BuildContext, TimeOfDay) timeFormatter;
}

String _defaultTimeFormatter(BuildContext context, TimeOfDay time) =>
    "${time.hour.toString().padLeft(2, '0')}:"
    "${time.minute.toString().padLeft(2, '0')}";

String _defaultDayMonthFormatter(BuildContext context, DateTime date) =>
    "${_getDayName(date.weekday)} ${date.day} ${_getMonthName(date.month)}";

String _defaultPeriodFormatter(BuildContext context, DateTimeRange range) =>
    "${range.start.day} ${_getMonthName(range.start.month)} to "
    "${range.end.day} ${_getMonthName(range.end.month)}";
String _defaultWeekDayAbbreviatedFormatter(
  BuildContext context,
  DateTime date,
) =>
    _getWeekDayAbbreviation(date.weekday);

String _defaultMonthYearFormatter(BuildContext context, DateTime date) =>
    "${_getMonthName(date.month)} ${date.year}";

String _getWeekDayAbbreviation(int weekday) =>
    _getDayName(weekday).substring(0, 2);

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

String _getDayName(int day) => switch (day) {
      1 => "Monday",
      2 => "Tuesday",
      3 => "Wednesday",
      4 => "Thursday",
      5 => "Friday",
      6 => "Saturday",
      7 => "Sunday",
      _ => "",
    };
