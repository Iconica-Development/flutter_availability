import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Returns the default local availabilities for a user
List<AvailabilityModel> getDefaultLocalAvailabilitiesForUser() {
  var currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  return [
    for (var availability in <(String, int, String)>[
      ("1", 0, "1"),
      ("2", 2, "2"),
      ("3", 3, "2"),
      ("4", 6, "4"),
      ("5", 8, "5"),
    ]) ...[
      AvailabilityModel(
        id: availability.$1,
        userId: "",
        startDate: DateTime(
          currentMonth.year,
          currentMonth.month,
          currentMonth.day + availability.$2,
        ),
        endDate: DateTime(
          currentMonth.year,
          currentMonth.month,
          currentMonth.day + availability.$2,
        ),
        breaks: [],
        templateId: availability.$3,
      ),
    ],
  ];
}

/// returns the default local templates for a user
List<AvailabilityTemplateModel> getDefaultLocalTemplatesForUser() {
  var currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  return [
    for (var template in <(String, String, int)>[
      ("1", "Morning", 0xFF0000FF),
      ("2", "Afternoon", 0xFF00FF00),
      ("3", "Evening", 0xFFFF0000),
      ("4", "Night", 0xFFFF00FF),
      ("5", "All day", 0xFF9999),
    ]) ...[
      AvailabilityTemplateModel(
        id: template.$1,
        userId: "",
        name: template.$2,
        color: template.$3,
        templateType: AvailabilityTemplateType.day,
        templateData: DayTemplateData(
          startTime: currentMonth,
          endTime: currentMonth,
          breaks: [],
        ),
      ),
    ],
  ];
}
