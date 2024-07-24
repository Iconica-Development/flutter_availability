import "package:flutter/material.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/view_models/break_view_model.dart";
import "package:flutter_availability/src/util/utils.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// The view model for the availability modification screen
/// This view model is used to manage the state of the availabilities while
/// editing them or creating new ones
class AvailabilityViewModel {
  ///
  const AvailabilityViewModel({
    required this.selectedRange,
    this.templates = const [],
    this.breaks = const [],
    this.ids = const [],
    this.userId,
    this.startTime,
    this.endTime,
    this.clearAvailability = false,
    this.conflictingPauses = false,
    this.conflictingTime = false,
    this.templateSelected = false,
  });

  /// This constructor creates a [AvailabilityViewModel] from a list of
  /// [AvailabilityWithTemplate] models
  /// It will check if the models have the same start and end time, breaks and
  /// if the entire selected range is covered by the models
  factory AvailabilityViewModel.fromModel(
    List<AvailabilityWithTemplate> models,
    DateTimeRange range,
  ) {
    var coveredByAvailabilities = _rangeIsCoveredWithAvailabilities(
      models.length,
      range,
    );
    var userId = models.firstOrNull?.availabilityModel.userId;
    // if there is no availability there is no conflicting time or pauses
    var conflictingPauses = models.isNotEmpty;
    var conflictingTime = models.isNotEmpty;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    var breaks = <BreakViewModel>[];

    if (coveredByAvailabilities) {
      var availabilities = models.getAvailabilities();
      if (_availabilityTimesAreEqual(availabilities)) {
        conflictingTime = false;
        startTime = TimeOfDay.fromDateTime(availabilities.first.startDate);
        endTime = TimeOfDay.fromDateTime(availabilities.first.endDate);
      }
      if (_availabilityBreaksAreEqual(availabilities)) {
        conflictingPauses = false;
        breaks = availabilities.first.breaks
            .map(BreakViewModel.fromAvailabilityBreakModel)
            .toList();
      }
    }

    return AvailabilityViewModel(
      templates: models.getUniqueTemplates(),
      breaks: breaks,
      ids: models.map((e) => e.availabilityModel.id!).toList(),
      userId: userId,
      startTime: startTime,
      endTime: endTime,
      conflictingPauses: conflictingPauses,
      conflictingTime: conflictingTime,
      selectedRange: range,
    );
  }

  /// The templates are selected for the availability range
  /// There can be multiple templates used in a selected range but only one
  /// template can be applied at a time
  final List<AvailabilityTemplateModel> templates;

  /// Whether the selected availability range should be cleared
  final bool clearAvailability;

  /// Whether the initial selected range has different pauses.
  /// If true an indication will be shown to the user that there are different
  /// pauses and the pause section will be empty. If the user then selects a new
  /// pause all the availabilities will be updated with the new pause.
  final bool conflictingPauses;

  /// Whether the initial selected range has different times
  /// If true an indication will be shown to the user that there are different
  /// times and the time section will be empty. If the user then selects a new
  /// time all the availabilities will be updated with the new time.
  final bool conflictingTime;

  /// Whether a new template has been selected for the availability
  /// If true a template will be applied, if false the availability will be
  /// changed but the template will not be applied again
  final bool templateSelected;

  /// The selected range for the availabilities
  /// This is used for applying templates
  final DateTimeRange selectedRange;

  /// The start time in the time selection while editing availabilities
  final TimeOfDay? startTime;

  /// The end time in the time selection while editing availabilities
  final TimeOfDay? endTime;

  /// The ids of the availabilities
  final List<String>? ids;

  /// The user id for which the availabilities are managed
  final String? userId;

  /// The configured breaks while editing availabilities
  final List<BreakViewModel> breaks;

  /// Whether the availability is valid
  bool get isValid => breaks.every((element) => element.isValid);

  /// Whether the save button should be enabled
  bool get canSave =>
      clearAvailability || (startTime != null && endTime != null);

  ///
  AvailabilityViewModel applyTemplate(AvailabilityTemplateModel template) {
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    var conflictingPauses = true;
    var conflictingTime = true;
    var breaks = <BreakViewModel>[];
    var appliedAvailabilities =
        template.apply(selectedRange.start, selectedRange.end);
    // If there are missing days in the range, the time cannot be applied
    if (_rangeIsCoveredWithAvailabilities(
      appliedAvailabilities.length,
      selectedRange,
    )) {
      if (_availabilityTimesAreEqual(appliedAvailabilities)) {
        conflictingTime = false;
        startTime =
            TimeOfDay.fromDateTime(appliedAvailabilities.first.startDate);
        endTime = TimeOfDay.fromDateTime(appliedAvailabilities.first.endDate);
      }
      if (_availabilityBreaksAreEqual(appliedAvailabilities)) {
        conflictingPauses = false;
        breaks = appliedAvailabilities.first.breaks
            .map(BreakViewModel.fromAvailabilityBreakModel)
            .toList();
      }
    }

    return clearTimeAndBreak().copyWith(
      templates: [template],
      breaks: breaks,
      conflictingPauses: conflictingPauses,
      conflictingTime: conflictingTime,
      startTime: startTime,
      endTime: endTime,
      templateSelected: true,
    );
  }

  /// Removes the templates from the availability
  AvailabilityViewModel removeTemplates() => copyWith(
        templates: [],
        templateSelected: false,
      );

  /// Removes the time and breaks from the availability
  AvailabilityViewModel clearTimeAndBreak() => AvailabilityViewModel(
        selectedRange: selectedRange,
        templates: templates,
        ids: ids,
        userId: userId,
        startTime: null,
        endTime: null,
        breaks: [],
        clearAvailability: clearAvailability,
        conflictingPauses: conflictingPauses,
        conflictingTime: conflictingTime,
        templateSelected: templateSelected,
      );

  /// create a AvailabilityModel from the current AvailabilityViewModel
  AvailabilityModel toModel() {
    var startDate = DateTime(
      selectedRange.start.year,
      selectedRange.start.month,
      selectedRange.start.day,
      startTime!.hour,
      startTime!.minute,
    );
    var endDate = DateTime(
      selectedRange.start.year,
      selectedRange.start.month,
      selectedRange.start.day,
      endTime!.hour,
      endTime!.minute,
    );
    return AvailabilityModel(
      id: ids?.firstOrNull,
      userId: userId ?? "",
      startDate: startDate,
      endDate: endDate,
      breaks: breaks.map((e) => e.toBreak()).toList(),
    );
  }

  /// Copies the current properties into a new instance
  /// of [AvailabilityViewModel],
  AvailabilityViewModel copyWith({
    List<AvailabilityTemplateModel>? templates,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<String>? ids,
    String? userId,
    List<BreakViewModel>? breaks,
    bool? clearAvailability,
    bool? conflictingPauses,
    bool? conflictingTime,
    bool? templateSelected,
    DateTimeRange? selectedRange,
  }) =>
      AvailabilityViewModel(
        templates: templates ?? this.templates,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        ids: ids ?? this.ids,
        userId: userId ?? this.userId,
        breaks: breaks ?? this.breaks,
        clearAvailability: clearAvailability ?? this.clearAvailability,
        conflictingPauses: conflictingPauses ?? this.conflictingPauses,
        conflictingTime: conflictingTime ?? this.conflictingTime,
        templateSelected: templateSelected ?? this.templateSelected,
        selectedRange: selectedRange ?? this.selectedRange,
      );
}

/// Checks if the availability times are equal
bool _availabilityTimesAreEqual(List<AvailabilityModel> availabilityModels) {
  var firstModel = availabilityModels.firstOrNull;
  if (firstModel == null) {
    return false;
  }
  var startDate = firstModel.startDate;
  var endDate = firstModel.endDate;
  return availabilityModels.every(
    (model) =>
        isAtSameTime(startDate, model.startDate) &&
        isAtSameTime(endDate, model.endDate),
  );
}

/// Checks if the availability breaks are equal
bool _availabilityBreaksAreEqual(List<AvailabilityModel> availabilityModels) {
  var firstModel = availabilityModels.firstOrNull;
  if (firstModel == null) {
    return false;
  }
  var breaks = firstModel.breaks;
  return availabilityModels.every((model) => model.breaksEqual(breaks));
}

/// Checks if there are as many availabilities as days in the range
bool _rangeIsCoveredWithAvailabilities(
  int amountOfAvailabilities,
  DateTimeRange range,
) =>
    amountOfAvailabilities == (range.duration.inDays + 1);
