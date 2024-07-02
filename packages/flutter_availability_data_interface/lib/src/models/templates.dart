import "package:flutter_availability_data_interface/src/models/availability.dart";

/// A limited set of different availability template types
enum AvailabilityTemplateType {
  /// A template that applies to any day, regardless of when it is.
  day,

  /// A template that applies on a per week basis, where for each day of the
  /// week a different template is given
  week;
}

/// A template to mass create availabilities
class AvailabilityTemplateModel {
  /// Create a new availability template
  const AvailabilityTemplateModel({
    required this.userId,
    required this.name,
    required this.color,
    required this.templateType,
    required this.templateData,
    this.id,
  });

  /// The identifier for this template
  final String? id;

  /// The user for whom the template is saved.
  final String userId;

  /// The name by which the template can be visually identified
  final String name;

  /// The color by which the template can be visually identified
  final int color;

  /// The type of template this is.
  ///
  /// This is used for parsing the template data to a model
  final AvailabilityTemplateType templateType;

  /// The specific data for this template
  final TemplateData templateData;
}

/// Used as the key for defining week-based templates
enum WeekDay {
  /// Representation for the first day in the week
  monday,

  /// Representation for the second day in the week
  tuesday,

  /// Representation for the third day in the week
  wednesday,

  /// Representation for the fourth day in the week
  thursday,

  /// Representation for the fifth day in the week
  friday,

  /// Representation for the sixth day in the week
  saturday,

  /// Representation for the seventh day in the week
  sunday;

  /// Finds the Weekday based on the given [dateTime], where
  /// [DateTime.monday] should return [WeekDay.monday].
  ///
  /// The datetime is 1-indexed, whilst the weekday is 0-indexed, hence that
  /// a -1 operation is applied to the weekday of the [dateTime]
  factory WeekDay.fromDateTime(DateTime dateTime) =>
      WeekDay.values[dateTime.weekday - 1];
}

/// Defines the interface all templatedata implementation need to apply to
///
/// ignore: one_member_abstracts
abstract interface class TemplateData {
  /// Applies the current template to all days found between [start] and [end],
  /// inclusive
  List<AvailabilityModel> apply({
    required DateTime start,
    required DateTime end,
  });
}

/// A week based template data structure
class WeekTemplateData implements TemplateData {
  /// Create a new week based template
  const WeekTemplateData({required Map<WeekDay, DayTemplateData> data})
      : _data = data;

  /// Alternative way of constructing a week based template for explicit weekday
  /// assignments
  factory WeekTemplateData.forDays({
    DayTemplateData? monday,
    DayTemplateData? tuesday,
    DayTemplateData? wednesday,
    DayTemplateData? thursday,
    DayTemplateData? friday,
    DayTemplateData? saturday,
    DayTemplateData? sunday,
  }) =>
      WeekTemplateData(
        data: {
          if (monday != null) WeekDay.monday: monday,
          if (tuesday != null) WeekDay.tuesday: tuesday,
          if (wednesday != null) WeekDay.wednesday: wednesday,
          if (thursday != null) WeekDay.thursday: thursday,
          if (friday != null) WeekDay.friday: friday,
          if (saturday != null) WeekDay.saturday: saturday,
          if (sunday != null) WeekDay.monday: sunday,
        },
      );

  final Map<WeekDay, DayTemplateData> _data;

  /// retrieves an unmodifiable map for each date.
  Map<WeekDay, DayTemplateData> get data => Map.unmodifiable(_data);

  @override
  List<AvailabilityModel> apply({
    required DateTime start,
    required DateTime end,
  }) {
    // TODO(Joey): Implement the apply method
    throw UnimplementedError();
  }
}

/// A day based template data structure
class DayTemplateData implements TemplateData {
  /// Create a new day based template
  const DayTemplateData({
    required this.startTime,
    required this.endTime,
    required this.breaks,
  });

  /// The start time to apply on a new availability
  final DateTime startTime;

  /// The start time to apply on a new availability
  final DateTime endTime;

  /// A list of breaks to apply to every new availability
  final List<AvailabilityBreakModel> breaks;

  @override
  List<AvailabilityModel> apply({
    required DateTime start,
    required DateTime end,
  }) {
    // TODO(Joey): Implement the apply method
    throw UnimplementedError();
  }
}
