import "package:flutter/material.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// The data for creating or editing a day template
class ViewDayTemplateData {
  /// Constructor
  const ViewDayTemplateData({
    this.startTime,
    this.endTime,
    this.breaks = const [],
  });

  /// Create a new instance from a [DayTemplateData]
  factory ViewDayTemplateData.fromDayTemplateData(DayTemplateData data) =>
      ViewDayTemplateData(
        startTime: TimeOfDay.fromDateTime(data.startTime),
        endTime: TimeOfDay.fromDateTime(data.endTime),
        breaks: data.breaks,
      );

  /// The start time to apply on a new availability
  final TimeOfDay? startTime;

  /// The start time to apply on a new availability
  final TimeOfDay? endTime;

  /// A list of breaks to apply to every new availability
  final List<AvailabilityBreakModel> breaks;

  /// Whether the data is valid for saving
  bool get isValid => startTime != null && endTime != null;

  /// Create a copy with new values
  ViewDayTemplateData copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<AvailabilityBreakModel>? breaks,
  }) =>
      ViewDayTemplateData(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        breaks: breaks ?? this.breaks,
      );

  /// Convert to [DayTemplateData]
  DayTemplateData toDayTemplateData() => DayTemplateData(
        startTime:
            DateTime(0, 0, 0, startTime?.hour ?? 0, startTime?.minute ?? 0),
        endTime: DateTime(0, 0, 0, endTime?.hour ?? 0, endTime?.minute ?? 0),
        breaks: breaks,
      );
}
