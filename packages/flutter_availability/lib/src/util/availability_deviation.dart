import "package:flutter_availability/src/util/utils.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Determines if the availability is deviated from the template that it is
/// based on
bool isTemplateDeviated(
  AvailabilityModel availability,
  AvailabilityTemplateModel template,
) {
  var dayOfWeek = availability.startDate.weekday;
  var templateStartDate =
      template.getStartTimeForDayOfWeek(WeekDay.values[dayOfWeek - 1]);
  var templateEndDate =
      template.getEndTimeForDayOfWeek(WeekDay.values[dayOfWeek - 1]);

  if (templateStartDate == null || templateEndDate == null) {
    return true;
  }

  var templateIsDeviated =
      !isAtSameTime(availability.startDate, templateStartDate) ||
          !isAtSameTime(availability.endDate, templateEndDate);
  return templateIsDeviated;
}
