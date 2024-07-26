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
    required this.availabilityTemplateDeviation,
    required this.overviewScreenTitle,
    required this.createTemplateButton,
    required this.clearAvailabilityButton,
    required this.clearAvailabilityConfirmTitle,
    required this.clearAvailabilityConfirmDescription,
    required this.unavailableForDay,
    required this.unavailableForMultipleDays,
    required this.availabilityAddTemplateTitle,
    required this.availabilityUsedTemplate,
    required this.availabilityUsedTemplates,
    required this.availabilityTimeTitle,
    required this.availabilitiesTimeTitle,
    required this.availabilityTemplateDeviationExplanation,
    required this.availabilitiesTemplateDeviationExplanation,
    required this.availabilitiesConflictingTimeExplanation,
    required this.availabilityDialogConfirmTitle,
    required this.availabilityDialogConfirmDescription,
    required this.templateScreenTitle,
    required this.dayTemplates,
    required this.weekTemplates,
    required this.createDayTemplate,
    required this.createWeekTemplate,
    required this.deleteTemplateButton,
    required this.editTemplateButton,
    required this.dayTemplateTitle,
    required this.weekTemplateTitle,
    required this.weekTemplateDayTitle,
    required this.templateTitleHintText,
    required this.templateTitleLabel,
    required this.templateColorLabel,
    required this.weekTemplateOverviewTitle,
    required this.templateDeleteDialogConfirmTitle,
    required this.templateDeleteDialogConfirmDescription,
    required this.pause,
    required this.unavailable,
    required this.time,
    required this.timeSeparator,
    required this.timeMinutes,
    required this.timeMinutesShort,
    required this.templateTimeLabel,
    required this.pauseSectionTitle,
    required this.pauseSectionOptional,
    required this.pauseDialogTitle,
    required this.pauseDialogDescriptionAvailability,
    required this.pauseDialogDescriptionTemplate,
    required this.pauseDialogPeriodTitle,
    required this.pauseDialogPeriodDescription,
    required this.saveButton,
    required this.addButton,
    required this.nextButton,
    required this.confirmText,
    required this.cancelText,
    required this.timeFormatter,
    required this.dayMonthFormatter,
    required this.periodFormatter,
    required this.monthYearFormatter,
    required this.weekDayAbbreviatedFormatter,
    required this.weekDayFormatter,
  });

  /// AvailabilityTranslations constructor where everything is optional.
  /// This provides default english values for the availability userstory.
  const AvailabilityTranslations.empty({
    this.appbarTitle = "Availability",
    this.editAvailabilityButton = "Edit availability",
    this.templateLegendTitle = "Templates",
    this.templateSelectionLabel = "Selected day(s)",
    this.availabilityWithoutTemplateLabel = "Availabilty without template",
    this.availabilityTemplateDeviation = "Template deviation",
    this.createTemplateButton = "Create a new template",
    this.clearAvailabilityButton = "Not available on these days",
    this.clearAvailabilityConfirmTitle = "Are you sure you want to clear?",
    this.clearAvailabilityConfirmDescription =
        "This will remove all availabilities for the selected days",
    this.unavailableForDay = "I am not available this day",
    this.unavailableForMultipleDays = "I am not available these days",
    this.availabilityAddTemplateTitle = "Add template to availability",
    this.availabilityUsedTemplate = "Used template",
    this.availabilityUsedTemplates = "Used templates",
    this.availabilityTimeTitle = "Start and end time workday",
    this.availabilitiesTimeTitle = "Start and end time workdays",
    this.availabilityTemplateDeviationExplanation =
        "The start and end time are deviating from the template for this day",
    this.availabilitiesTemplateDeviationExplanation =
        "The start and end time are deviating from the template for these days",
    this.availabilitiesConflictingTimeExplanation =
        "There are conflicting times when applying this template "
            "for this period",
    this.availabilityDialogConfirmTitle =
        "Are you sure you want to save the changes?",
    this.availabilityDialogConfirmDescription =
        "This will update your availabilities but you can always "
            "change them later",
    this.overviewScreenTitle = "Availability",
    this.templateScreenTitle = "Templates",
    this.dayTemplates = "Day templates",
    this.weekTemplates = "Week templates",
    this.createDayTemplate = "Create day template",
    this.createWeekTemplate = "Create week template",
    this.deleteTemplateButton = "Delete template",
    this.editTemplateButton = "Edit template",
    this.dayTemplateTitle = "Day template",
    this.weekTemplateTitle = "Week template",
    this.weekTemplateDayTitle = "When",
    this.templateTitleHintText = "What do you want to call this template?",
    this.templateTitleLabel = "Template Title",
    this.templateColorLabel = "Colorlabel",
    this.weekTemplateOverviewTitle = "Overview availability",
    this.templateDeleteDialogConfirmTitle = "Are you sure you want to delete?",
    this.templateDeleteDialogConfirmDescription =
        "You can't undo this deletion",
    this.pause = "Pause",
    this.unavailable = "Unavailable",
    this.time = "Time",
    this.timeSeparator = "to",
    this.timeMinutes = "minutes",
    this.timeMinutesShort = "min",
    this.templateTimeLabel = "When are you available?",
    this.pauseSectionTitle = "Add a pause",
    this.pauseSectionOptional = "(Optional)",
    this.pauseDialogTitle = "Add a pause",
    this.pauseDialogDescriptionAvailability =
        "Add a pause to your availability. "
            "Choose how long you want to take a break",
    this.pauseDialogDescriptionTemplate = "Add a pause to this template. "
        "Choose how long you want to take a break",
    this.pauseDialogPeriodTitle = "Time slot",
    this.pauseDialogPeriodDescription =
        "Select between which times you want to take a break",
    this.saveButton = "Save",
    this.addButton = "Add",
    this.nextButton = "Next",
    this.confirmText = "Yes",
    this.cancelText = "No",
    this.dayMonthFormatter = _defaultDayMonthFormatter,
    this.periodFormatter = _defaultPeriodFormatter,
    this.monthYearFormatter = _defaultMonthYearFormatter,
    this.weekDayAbbreviatedFormatter = _defaultWeekDayAbbreviatedFormatter,
    this.weekDayFormatter = _defaultWeekDayFormatter,
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

  /// The hint text for the availability template deviation
  final String availabilityTemplateDeviation;

  /// The title on the overview screen
  final String overviewScreenTitle;

  /// The label on the button to go to the template screen
  final String createTemplateButton;

  /// The text shown on the button to clear the selected range on the
  /// overview page
  final String clearAvailabilityButton;

  /// The title for the confirmation dialog when clearing the availability
  final String clearAvailabilityConfirmTitle;

  /// The description for the confirmation dialog when clearing the availability
  final String clearAvailabilityConfirmDescription;

  /// The text shown to clear the availability for a day
  final String unavailableForDay;

  /// The text shown to clear the availability for multiple days
  final String unavailableForMultipleDays;

  /// The title on the template selection section for adding availabilities
  final String availabilityAddTemplateTitle;

  /// The title on the template selection section when a single template is used
  final String availabilityUsedTemplate;

  /// The title on the template selection section when more templates are used
  final String availabilityUsedTemplates;

  /// The title on the time selection section for adding a single availability
  final String availabilityTimeTitle;

  /// The title on the time selection section for adding multiple availabilities
  final String availabilitiesTimeTitle;

  /// The explainer text when the availability deviates from the used template
  /// on the availability modification screen
  final String availabilityTemplateDeviationExplanation;

  /// The explainer text when one of the availabilities deviates from the used
  /// template on the availability modification screen
  final String availabilitiesTemplateDeviationExplanation;

  /// The explainer text when the availabilities have conflicting times when
  /// applying a template and the start and end time have not been filled in
  final String availabilitiesConflictingTimeExplanation;

  /// The title on the dialog for confirming the availability update
  final String availabilityDialogConfirmTitle;

  /// The description on the dialog for confirming the availability update
  final String availabilityDialogConfirmDescription;

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

  /// The label on the button to edit a template
  final String editTemplateButton;

  /// The title for the day template edit screen
  final String dayTemplateTitle;

  /// The title for the week template edit screen
  final String weekTemplateTitle;

  /// The title above the section with the week template days
  final String weekTemplateDayTitle;

  /// The hint text for the template title input field
  final String templateTitleHintText;

  /// The label for the template title input field
  final String templateTitleLabel;

  /// The title above the color selection for templates
  final String templateColorLabel;

  /// The title for the week overview section
  final String weekTemplateOverviewTitle;

  /// The title on the dialog for confirming the template delete
  final String templateDeleteDialogConfirmTitle;

  /// The description on the dialog for confirming the template delete
  final String templateDeleteDialogConfirmDescription;

  /// The label used for pause
  final String pause;

  /// The label used for unavailable
  final String unavailable;

  /// The title for time sections
  final String time;

  /// The text between start and end time
  final String timeSeparator;

  /// The text used for minutes
  final String timeMinutes;

  /// The text used for minutes in a short form
  final String timeMinutesShort;

  /// The label for the template time input
  final String templateTimeLabel;

  /// The title for pause configuration sections
  final String pauseSectionTitle;

  /// The label for optional indication on pause sections
  final String pauseSectionOptional;

  /// The title for the pause dialog
  final String pauseDialogTitle;

  /// The description for the pause dialog displayed below the title
  /// This is used for availability modification
  final String pauseDialogDescriptionAvailability;

  /// The description for the pause dialog displayed below the title
  /// This is used for template modification
  final String pauseDialogDescriptionTemplate;

  /// The title for the section in the pause dialog where you select the period
  final String pauseDialogPeriodTitle;

  /// The description for the section in the pause dialog where you select
  /// the period
  final String pauseDialogPeriodDescription;

  /// The text on the save button
  final String saveButton;

  /// The text on the add button
  final String addButton;

  /// The text on the next button
  final String nextButton;

  /// The text on the confirm button in the confirmation dialog
  final String confirmText;

  /// The text on the cancel button in the confirmation dialog
  final String cancelText;

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

  /// Gets the weekday formatted as a string
  ///
  /// The default implementation is the full name of the weekday in english
  final String Function(BuildContext, DateTime) weekDayFormatter;

  /// Get the time formatted as a string
  ///
  /// The default implementation is `HH:mm`
  final String Function(BuildContext, TimeOfDay) timeFormatter;
}

String _defaultWeekDayFormatter(BuildContext context, DateTime date) =>
    _getDayName(date.weekday);

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
