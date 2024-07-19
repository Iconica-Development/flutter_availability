import "package:flutter/material.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// View model to represent the data during the modification of a break
class BreakViewModel {
  /// Constructor
  const BreakViewModel({
    this.startTime,
    this.endTime,
    this.submittedDuration,
  });

  /// Create a [BreakViewModel] from a [AvailabilityBreakModel]
  factory BreakViewModel.fromAvailabilityBreakModel(
    AvailabilityBreakModel data,
  ) =>
      BreakViewModel(
        startTime: TimeOfDay.fromDateTime(data.startTime),
        endTime: TimeOfDay.fromDateTime(data.endTime),
        submittedDuration: data.submittedDuration,
      );

  /// The start time for this break
  final TimeOfDay? startTime;

  /// The end time for this break
  final TimeOfDay? endTime;

  /// The full duration of the actual break. This is filled in by the users and
  /// stays null if the user has not filled it in.
  ///
  /// This is allowed to diverge from the difference between [startTime] and
  /// [endTime] to indicate that the break is somewhere between [startTime] and
  /// [endTime]
  final Duration? submittedDuration;

  /// Get the duration of the break
  /// If the duration is null, return the difference between the start and end
  /// time in minutes
  Duration get duration => submittedDuration ?? toBreak().duration;

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
    if (submittedDuration == null) {
      return true;
    }
    var actualDuration = endDateTime.difference(startDateTime);
    return submittedDuration! <= actualDuration;
  }

  /// Whether the save/next button should be enabled
  bool get canSave => startTime != null && endTime != null;

  /// Convert to [AvailabilityBreakModel] for saving
  AvailabilityBreakModel toBreak() => AvailabilityBreakModel(
        startTime:
            DateTime(0, 0, 0, startTime?.hour ?? 0, startTime?.minute ?? 0),
        endTime: DateTime(0, 0, 0, endTime?.hour ?? 0, endTime?.minute ?? 0),
        submittedDuration: submittedDuration,
      );

  /// Create a copy with new values
  BreakViewModel copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Duration? submittedDuration,
  }) =>
      BreakViewModel(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        submittedDuration: submittedDuration ?? this.submittedDuration,
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

  /// Clear the duration of the break
  BreakViewModel clearDuration() => BreakViewModel(
        startTime: startTime,
        endTime: endTime,
        submittedDuration: null,
      );
}
