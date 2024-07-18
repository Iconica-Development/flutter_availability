import "package:flutter/material.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// View model to represent the data during the modification of a break
class BreakViewModel {
  /// Constructor
  const BreakViewModel({
    this.startTime,
    this.endTime,
    this.duration,
  });

  /// Create a [BreakViewModel] from a [AvailabilityBreakModel]
  factory BreakViewModel.fromAvailabilityBreakModel(
    AvailabilityBreakModel data,
  ) =>
      BreakViewModel(
        startTime: TimeOfDay.fromDateTime(data.startTime),
        endTime: TimeOfDay.fromDateTime(data.endTime),
        duration: data.duration,
      );

  /// The start time for this break
  final TimeOfDay? startTime;

  /// The end time for this break
  final TimeOfDay? endTime;

  /// The full duration of the actual break.
  ///
  /// This is allowed to diverge from the difference between [startTime] and
  /// [endTime] to indicate that the break is somewhere between [startTime] and
  /// [endTime]
  final Duration? duration;

  /// Get the duration in minutes
  /// If the duration is null, return the difference between the start and end
  /// time in minutes
  int get durationInMinutes =>
      duration?.inMinutes ??
      ((endTime!.hour * 60 + endTime!.minute) -
          (startTime!.hour * 60 + startTime!.minute));

  /// Returns true if the break is valid
  /// The start is before the end and the duration is equal or lower than the
  /// difference between the start and end
  bool get isValid {
    if (startTime == null || endTime == null) {
      return false;
    }
    var startDateTime = DateTime(0, 1, 1, startTime!.hour, startTime!.minute);
    var endDateTime = DateTime(0, 1, 1, endTime!.hour, endTime!.minute);

    if (startDateTime.isAfter(endDateTime)) {
      return false;
    }
    if (duration == null) {
      return true;
    }
    var actualDuration = endDateTime.difference(startDateTime);
    return duration! <= actualDuration;
  }

  /// Whether the save/next button should be enabled
  bool get canSave => startTime != null && endTime != null;

  /// Convert to [AvailabilityBreakModel] for saving
  AvailabilityBreakModel toBreak() => AvailabilityBreakModel(
        startTime: DateTime(0, 0, 0, startTime!.hour, startTime!.minute),
        endTime: DateTime(0, 0, 0, endTime!.hour, endTime!.minute),
        duration: duration,
      );

  /// Create a copy with new values
  BreakViewModel copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Duration? duration,
  }) =>
      BreakViewModel(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        duration: duration ?? this.duration,
      );

  /// compareto method to order two breaks based on their start time
  /// multiples hours are converted to minutes and added to the minutes
  int compareTo(BreakViewModel other) {
    var difference = startTime!.hour * 60 +
        startTime!.minute -
        other.startTime!.hour * 60 -
        other.startTime!.minute;
    return difference;
  }
}
