// ignore_for_file: Generated using data class generator
/// A model defining the data structure for an availability
class AvailabilityModel {
  /// Creates a new availability
  const AvailabilityModel({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.breaks,
    this.id,
    this.templateId,
  });

  /// the identifier for this availability
  final String? id;

  /// The uniquely identifiable string for who or what the
  final String userId;

  /// The identifier of the [AvailabilityTemplateModel] that this availability
  /// is associated with if any.
  final String? templateId;

  /// The from date of this availability.
  ///
  /// [startDate] will always have to be before the end date.
  final DateTime startDate;

  /// The until date of this availability
  ///
  /// [endDate] will always be after the start date.
  final DateTime endDate;

  /// A list of breaks during the specified time period
  final List<AvailabilityBreakModel> breaks;

  /// Copies the current properties into a new instance of [AvailabilityModel],
  /// except for the properties provided to this method.
  AvailabilityModel copyWith({
    String? id,
    String? userId,
    String? templateId,
    DateTime? startDate,
    DateTime? endDate,
    List<AvailabilityBreakModel>? breaks,
  }) =>
      AvailabilityModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        templateId: templateId ?? this.templateId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        breaks: breaks ?? this.breaks,
      );

  /// returns true if the date of the availability overlaps with the given range
  /// This disregards the time of the date
  bool isInRange(DateTime start, DateTime end) {
    var startDate = DateTime(start.year, start.month, start.day);
    var endDate = DateTime(end.year, end.month, end.day);
    var availabilityStartDate = DateTime(
      this.startDate.year,
      this.startDate.month,
      this.startDate.day,
    );
    var availabilityEndDate = DateTime(
      this.endDate.year,
      this.endDate.month,
      this.endDate.day,
    );

    return (startDate.isBefore(availabilityEndDate) ||
            startDate.isAtSameMomentAs(availabilityEndDate)) &&
        (endDate.isAfter(availabilityStartDate) ||
            endDate.isAtSameMomentAs(availabilityStartDate));
  }
}

/// A model defining the structure of a break within an [AvailabilityModel]
class AvailabilityBreakModel {
  /// Create a new AvailabilityBreakModel
  const AvailabilityBreakModel({
    required this.startTime,
    required this.endTime,
    this.submittedDuration,
  });

  /// Parses a break from a map.
  ///
  /// This function is primarily used in the storing of template blobs. For each
  /// variant of the service it is recommended to implement your own
  /// serialization layer.
  factory AvailabilityBreakModel.fromMap(Map<String, dynamic> map) =>
      AvailabilityBreakModel(
        startTime:
            DateTime.fromMillisecondsSinceEpoch((map["startTime"] ?? 0) as int),
        endTime:
            DateTime.fromMillisecondsSinceEpoch((map["endTime"] ?? 0) as int),
        submittedDuration: map["duration"] != null
            ? Duration(minutes: map["duration"] as int)
            : null,
      );

  /// The start time for this break
  ///
  /// If duration is not the same as the difference between [startTime] and
  /// [endTime], the [startTime] is considered the start of the period of which
  /// a break of [submittedDuration] can be held.
  final DateTime startTime;

  /// The end time for this break
  ///
  /// If duration is not the same as the difference between [startTime] and
  /// [endTime], the [endTime] is considered the end of the period of which
  /// a break of [submittedDuration] can be held.
  final DateTime endTime;

  /// The full duration of the actual break. This is filled in by the users and
  /// stays null if the user has not filled it in.
  ///
  /// This is allowed to diverge from the difference between [startTime] and
  /// [endTime] to indicate that the break is somewhere between [startTime] and
  /// [endTime]
  final Duration? submittedDuration;

  /// Results in the set duration, or the difference between [startTime] and
  /// [endTime] if no duration is set.
  Duration get duration => submittedDuration ?? period;

  /// The period in which the break will take place.
  ///
  /// Will be the same as [duration] if the initial [submittedDuration] is null
  Duration get period => endTime.difference(startTime);

  /// Whether the duration of the break matches the difference between
  /// [startTime] and [endTime]
  bool get isTight => submittedDuration == null || submittedDuration == period;

  /// Copies the current properties into a new instance of
  /// [AvailabilityBreakModel], except for the properties provided
  /// to this method.
  AvailabilityBreakModel copyWith({
    DateTime? startTime,
    DateTime? endTime,
    Duration? submittedDuration,
  }) =>
      AvailabilityBreakModel(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        submittedDuration: submittedDuration ?? this.submittedDuration,
      );

  /// Returns a map variant of this object.
  ///
  /// This is mainly for serialization of template data. Serialization of this
  /// object for persistance in your own implementation is recommended to be
  /// done in a separate serialization layer.
  Map<String, dynamic> toMap() => <String, dynamic>{
        "startTime": startTime.millisecondsSinceEpoch,
        "endTime": endTime.millisecondsSinceEpoch,
        "duration": submittedDuration?.inMinutes,
      };
}
