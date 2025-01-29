/// Accessibility identifiers for all widgets in the availability userstory that
/// need to be interacted with by e2e tests. This includes buttons, textfields,
/// and dynamic texts.
class AvailabilityAccessibilityIds {
  /// default [AvailabilityAccessibilityIds] constructor where all the
  /// identifiers are required. This is to ensure that apps automatically break
  /// when new identifiers are added.
  const AvailabilityAccessibilityIds({
    required this.monthNameTextIdentifier,
    required this.previousMonthButtonIdentifier,
    required this.nextMonthButtonIdentifier,
    required this.availabilityDateButtonIdentifier,
    required this.createNewTemplateButtonIdentifier,
    required this.viewAvailabilitiesButtonIdentifier,
    required this.clearAvailabilitiesButtonIdentifier,
    required this.toggleTemplateDrawerButtonIdentifier,
    required this.availabilitiesPeriodTextIdentifier,
    required this.selectUnavailableForPeriodButtonIdentifier,
    required this.addTemplateToAvailabilitiesButtonIdentifier,
    required this.removeTemplatesFromAvailabilitiesButtonIdentifier,
    required this.createNewDayTemplateButtonIdentifier,
    required this.createNewWeekTemplateButtonIdentifier,
    required this.dayTemplateEditButtonIdentifier,
    required this.weekTemplateEditButtonIdentifier,
    required this.templateNameTextFieldIdentifier,
    required this.startTimeTextFieldIdentifier,
    required this.endTimeTextFieldIdentifier,
    required this.durationTextFieldIdentifier,
    required this.addBreaksButtonIdentifier,
    required this.editBreakButtonIdentifier,
    required this.deleteBreakButtonIdentifier,
    required this.colorSelectionButtonIdentifier,
    required this.colorSelectedButtonIdentifier,
    required this.weekDayButtonIdentifier,
    required this.weekDayTimeIdentifier,
    required this.weekDayBreakIdentifier,
    required this.templateNameIdentifier,
    required this.deleteTemplateButtonIdentifier,
    required this.saveButtonIdentifier,
    required this.addButtonIdentifier,
    required this.nextButtonIdentifier,
    required this.closeButtonIdentifier,
  });

  /// Empty [AvailabilityAccessibilityIds] constructor where all the identifiers
  ///  are already set to their default values. You can override all or some of
  /// the default values.
  const AvailabilityAccessibilityIds.empty({
    this.monthNameTextIdentifier = "text_month_name",
    this.previousMonthButtonIdentifier = "button_previous_month",
    this.nextMonthButtonIdentifier = "button_next_month",
    this.availabilityDateButtonIdentifier = "button_availability_date",
    this.createNewTemplateButtonIdentifier = "button_create_template",
    this.viewAvailabilitiesButtonIdentifier = "button_view_availabilities",
    this.clearAvailabilitiesButtonIdentifier = "button_clear_availabilities",
    this.toggleTemplateDrawerButtonIdentifier = "button_toggle_template_drawer",
    this.availabilitiesPeriodTextIdentifier = "text_availabilities_period",
    this.selectUnavailableForPeriodButtonIdentifier =
        "button_select_unavailable_for_period",
    this.addTemplateToAvailabilitiesButtonIdentifier =
        "button_add_template_to_availabilities",
    this.removeTemplatesFromAvailabilitiesButtonIdentifier =
        "button_remove_templates_from_availabilities",
    this.createNewDayTemplateButtonIdentifier = "button_create_template_day",
    this.createNewWeekTemplateButtonIdentifier = "button_create_template_week",
    this.dayTemplateEditButtonIdentifier = "button_edit_template_day",
    this.weekTemplateEditButtonIdentifier = "button_edit_template_week",
    this.templateNameTextFieldIdentifier = "textfield_template_name",
    this.startTimeTextFieldIdentifier = "textfield_start_time",
    this.endTimeTextFieldIdentifier = "textfield_end_time",
    this.durationTextFieldIdentifier = "textfield_duration",
    this.addBreaksButtonIdentifier = "button_add_breaks",
    this.editBreakButtonIdentifier = "button_edit_break",
    this.deleteBreakButtonIdentifier = "button_delete_break",
    this.colorSelectionButtonIdentifier = "button_select_color",
    this.colorSelectedButtonIdentifier = "button_selected_color",
    this.weekDayButtonIdentifier = "button_select_week_day",
    this.weekDayTimeIdentifier = "text_week_day_time",
    this.weekDayBreakIdentifier = "text_week_day_break",
    this.templateNameIdentifier = "text_template_name",
    this.deleteTemplateButtonIdentifier = "button_delete_template",
    this.saveButtonIdentifier = "button_save",
    this.addButtonIdentifier = "button_add",
    this.nextButtonIdentifier = "button_next",
    this.closeButtonIdentifier = "button_close",
  });

  /// The identifier for the text that displays the month that is being viewed
  final String monthNameTextIdentifier;

  /// The identifier for the button to navigate to the previous month
  final String previousMonthButtonIdentifier;

  /// The identifier for the button to navigate to the next month
  final String nextMonthButtonIdentifier;

  /// The identifier for the button to select a date in the availability view
  /// The month and day are appended to this identifier
  final String availabilityDateButtonIdentifier;

  /// The identifier for the button to go template overview screen
  final String createNewTemplateButtonIdentifier;

  /// The identifier for the button to view availabilities
  final String viewAvailabilitiesButtonIdentifier;

  /// The identifier for the button to clear availabilities;
  final String clearAvailabilitiesButtonIdentifier;

  /// The identifier for the button to toggle the template drawer
  final String toggleTemplateDrawerButtonIdentifier;

  /// The identifier for the text that displays the period of availabilities
  /// that are being viewed
  final String availabilitiesPeriodTextIdentifier;

  /// The identifier for the checkbox to clear all availabilities for a period
  final String selectUnavailableForPeriodButtonIdentifier;

  /// The identifier for the button to add a template to a selection of
  /// availabilities
  final String addTemplateToAvailabilitiesButtonIdentifier;

  /// The identifier for the button to remove all templates from a selection of
  /// availabilities
  final String removeTemplatesFromAvailabilitiesButtonIdentifier;

  /// The identifier for the button to create a new day template
  final String createNewDayTemplateButtonIdentifier;

  /// The identifier for the button to create a new week template
  final String createNewWeekTemplateButtonIdentifier;

  /// The identifier for the button to edit a specific day template, the index
  /// of the item in the list is appended to this identifier
  final String dayTemplateEditButtonIdentifier;

  /// The identifier for the button to edit a specific week template, the index
  /// of the item in the list is appended to this identifier
  final String weekTemplateEditButtonIdentifier;

  /// The identifier for the textfield to edit the name of a template
  final String templateNameTextFieldIdentifier;

  /// The identifier for the textfield to edit a start time
  final String startTimeTextFieldIdentifier;

  /// The identifier for the textfield to edit an end time
  final String endTimeTextFieldIdentifier;

  /// The identifier for the textfield to edit a duration
  final String durationTextFieldIdentifier;

  /// The identifier for the button to add new breaks
  final String addBreaksButtonIdentifier;

  /// The identifier for the break edit button to edit a specific break, the
  /// index of the item in the list is appended to this identifier
  final String editBreakButtonIdentifier;

  /// The identifier for the break delete button to delete a specific break, the
  /// index of the item in the list is appended to this identifier
  final String deleteBreakButtonIdentifier;

  /// The identifier for the button to select a color from the list of colors,
  /// the index of the item in the list is appended to this identifier
  final String colorSelectionButtonIdentifier;

  /// The identifier for the button for the currently selected color from the
  /// list of colors. This overrides [colorSelectionButtonIdentifier]
  final String colorSelectedButtonIdentifier;

  /// The identifier for the button to select a day of the week in the template
  /// modification screen. The index of the day is appended to this identifier
  final String weekDayButtonIdentifier;

  /// The identifier for the time of a day in the template view
  /// The index of the day is appended to this identifier
  final String weekDayTimeIdentifier;

  /// The identifier for the time of a break in the template view
  /// The index of the day and time is appended to this identifier
  final String weekDayBreakIdentifier;

  /// The identifier for the name of a template
  final String templateNameIdentifier;

  /// The identifier for the button to delete a template
  final String deleteTemplateButtonIdentifier;

  /// The identifier for the button to save (templates or availabilities)
  final String saveButtonIdentifier;

  /// The identifier for the button to save breaks
  final String addButtonIdentifier;

  /// The identifier for the button to navigate to next step for week templates
  final String nextButtonIdentifier;

  /// The identifier for the button to close a dialog
  final String closeButtonIdentifier;
}
