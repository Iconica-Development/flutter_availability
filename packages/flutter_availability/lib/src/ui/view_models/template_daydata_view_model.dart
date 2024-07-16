import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/view_models/break_view_model.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// The data for creating or editing a day template
class DayTemplateDataViewModel {
  /// Constructor
  const DayTemplateDataViewModel({
    this.startTime,
    this.endTime,
    this.breaks = const [],
  });

  /// Create a new instance from a [DayTemplateData]
  factory DayTemplateDataViewModel.fromDayTemplateData(DayTemplateData data) =>
      DayTemplateDataViewModel(
        startTime: TimeOfDay.fromDateTime(data.startTime),
        endTime: TimeOfDay.fromDateTime(data.endTime),
        breaks:
            data.breaks.map(BreakViewModel.fromAvailabilityBreakModel).toList(),
      );

  /// The start time to apply on a new availability
  final TimeOfDay? startTime;

  /// The start time to apply on a new availability
  final TimeOfDay? endTime;

  /// A list of breaks to apply to every new availability
  final List<BreakViewModel> breaks;

  /// Whether the data is valid
  /// The start is before the end
  /// There are no breaks that are invalid
  /// The breaks are not outside the start and end time
  /// The breaks are not overlapping
  bool get isValid => canSave && breaks.every((b) => b.isValid);

  /// Whether the save/next button should be enabled
  bool get canSave => startTime != null && endTime != null;

  /// Whether the day is empty and can be removed from the template when saving
  bool get isEmpty => startTime == null && endTime == null && breaks.isEmpty;

  /// Create a copy with new values
  DayTemplateDataViewModel copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<BreakViewModel>? breaks,
  }) =>
      DayTemplateDataViewModel(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        breaks: breaks ?? this.breaks,
      );

  /// Convert to [DayTemplateData]
  DayTemplateData toDayTemplateData() => DayTemplateData(
        startTime:
            DateTime(0, 0, 0, startTime?.hour ?? 0, startTime?.minute ?? 0),
        endTime: DateTime(0, 0, 0, endTime?.hour ?? 0, endTime?.minute ?? 0),
        breaks: breaks.map((b) => b.toBreak()).toList(),
      );
}
