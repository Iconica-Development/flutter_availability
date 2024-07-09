import "package:flutter_availability/src/util/utils.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Determines if the availability is deviated from the template that it is
/// based on
bool isTemplateDeviated(
  AvailabilityModel availability,
  AvailabilityTemplateModel template,
) {
  var dayOfWeek = availability.startDate.weekday;
  DateTime? templateStartDate;
  DateTime? templateEndDate;

  if (template.templateType == AvailabilityTemplateType.week) {
    templateStartDate = (template.templateData as WeekTemplateData)
        .data[WeekDay.values[dayOfWeek - 1]]
        ?.startTime;
    templateEndDate = (template.templateData as WeekTemplateData)
        .data[WeekDay.values[dayOfWeek - 1]]
        ?.endTime;
  } else {
    templateStartDate = (template.templateData as DayTemplateData).startTime;
    templateEndDate = (template.templateData as DayTemplateData).endTime;
  }

  if (templateStartDate == null || templateEndDate == null) {
    return true;
  }

  var templateIsDeviated =
      !isAtSameTime(availability.startDate, templateStartDate) ||
          !isAtSameTime(availability.endDate, templateEndDate);
  return templateIsDeviated;
}
