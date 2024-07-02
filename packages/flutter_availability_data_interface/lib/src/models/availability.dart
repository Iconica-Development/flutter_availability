/// A model defining the data structure for an availability
class AvailabilityModel {
  /// Creates a new availability
  const AvailabilityModel({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.breaks,
    this.id,
  });

  /// the identifier for this availability
  final String? id;

  /// The uniquely identifiable string for who or what the
  final String userId;

  /// The from date of this availability.
  ///
  /// [startDate] will always have to be before the end date.
  final DateTime startDate;

  /// The until date of this availability
  ///
  /// [endDate] will always be before the start date.
  final DateTime endDate;

  /// A list of breaks during the specified time period
  final List<AvailabilityBreakModel> breaks;

  /// Copies the current properties into a new instance of [AvailabilityModel],
  /// except for the properties provided to this method.
  AvailabilityModel copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    List<AvailabilityBreakModel>? breaks,
  }) =>
      AvailabilityModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        breaks: breaks ?? this.breaks,
      );
}

/// A model defining the structure of a break within an [AvailabilityModel]
class AvailabilityBreakModel {
  /// Create a new AvailabilityBreakModel
  const AvailabilityBreakModel({
    required this.startTime,
    required this.endTime,
    Duration? duration,
  }) : _duration = duration;

  /// The start time for this break
  ///
  /// If duration is not the same as the difference between [startTime] and
  /// [endTime], the [startTime] is considered the start of the period of which
  /// a break of [_duration] can be held.
  final DateTime startTime;

  /// The end time for this break
  ///
  /// If duration is not the same as the difference between [startTime] and
  /// [endTime], the [endTime] is considered the end of the period of which
  /// a break of [_duration] can be held.
  final DateTime endTime;

  /// The full duration of the actual break.
  ///
  /// This is allowed to diverge from the difference between [startTime] and
  /// [endTime] to indicate that the break is somewhere between [startTime] and
  /// [endTime]
  final Duration? _duration;

  /// Results in the set duration, or the difference between [startTime] and
  /// [endTime] if no duration is set.
  Duration get duration => _duration ?? period;

  /// The period in which the break will take place.
  ///
  /// Will be the same as [duration] if the initial [_duration] is null
  Duration get period => endTime.difference(startTime);

  /// Whether the duration of the break matches the difference between
  /// [startTime] and [endTime]
  bool get isTight => _duration == null || _duration == period;

  /// Copies the current properties into a new instance of
  /// [AvailabilityBreakModel], except for the properties provided
  /// to this method.
  AvailabilityBreakModel copyWith({
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
  }) =>
      AvailabilityBreakModel(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        duration: duration ?? _duration,
      );
}
