import "package:flutter/material.dart";
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
        // TODO(Joey): Even though this is testdata, Never use .add(duration)
        // to move to the next day.
        startDate: currentMonth.add(Duration(days: availability.$2)),
        endDate: currentMonth.add(Duration(days: availability.$2)),
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
    for (var template in <(String, String, Color)>[
      ("1", "Morning", Colors.blue),
      ("2", "Afternoon", Colors.green),
      ("3", "Evening", Colors.red),
      ("4", "Night", Colors.purple),
      ("5", "All day", Colors.orange),
    ]) ...[
      AvailabilityTemplateModel(
        id: template.$1,
        userId: "",
        name: template.$2,
        color: template.$3.value,
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
