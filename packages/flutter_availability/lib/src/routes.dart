import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/screens/availability_modification.dart";
import "package:flutter_availability/src/ui/screens/availability_overview.dart";
import "package:flutter_availability/src/ui/screens/template_day_modification.dart";
import "package:flutter_availability/src/ui/screens/template_overview.dart";
import "package:flutter_availability/src/ui/screens/template_week_modification.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
MaterialPageRoute homePageRoute(VoidCallback onExit) => MaterialPageRoute(
      builder: (context) => AvailabilityOverview(
        onEditDateRange: (range, availabilities) async => Navigator.of(context)
            .push(availabilityViewRoute(range, availabilities)),
        onViewTemplates: () async =>
            Navigator.of(context).push(templateOverviewRoute()),
        onExit: () => onExit(),
      ),
    );

Future _routeToTemplateEditScreen(
  BuildContext context,
  AvailabilityTemplateModel template,
) async {
  if (template.templateType == AvailabilityTemplateType.day) {
    await Navigator.of(context).push(templateEditDayRoute(template));
  } else if (template.templateType == AvailabilityTemplateType.week) {
    await Navigator.of(context).push(templateEditWeekRoute(template));
  }
}

///
MaterialPageRoute<AvailabilityTemplateModel?> templateOverviewRoute({
  bool allowSelection = false,
}) =>
    MaterialPageRoute(
      builder: (context) => AvailabilityTemplateOverview(
        onExit: () => Navigator.of(context).pop(),
        onEditTemplate: (template) async =>
            _routeToTemplateEditScreen(context, template),
        onAddTemplate: (type) async {
          if (type == AvailabilityTemplateType.day) {
            await Navigator.of(context).push(templateEditDayRoute(null));
          } else if (type == AvailabilityTemplateType.week) {
            await Navigator.of(context).push(templateEditWeekRoute(null));
          }
        },
        onSelectTemplate: (template) async {
          if (allowSelection) {
            Navigator.of(context).pop(template);
          } else {
            await _routeToTemplateEditScreen(context, template);
          }
        },
      ),
    );

///
MaterialPageRoute templateEditDayRoute(AvailabilityTemplateModel? template) =>
    MaterialPageRoute(
      builder: (context) => DayTemplateModificationScreen(
        template: template,
        onExit: () => Navigator.of(context).pop(),
      ),
    );

///
MaterialPageRoute templateEditWeekRoute(AvailabilityTemplateModel? template) =>
    MaterialPageRoute(
      builder: (context) => WeekTemplateModificationScreen(
        template: template,
        onExit: () => Navigator.of(context).pop(),
      ),
    );

///
MaterialPageRoute availabilityViewRoute(
  DateTimeRange dateRange,
  List<AvailabilityWithTemplate> initialAvailabilities,
) =>
    MaterialPageRoute(
      builder: (context) => AvailabilitiesModificationScreen(
        dateRange: dateRange,
        initialAvailabilities: initialAvailabilities,
        onTemplateSelection: () async {
          var selectedTemplate = Navigator.of(context)
              .push(templateOverviewRoute(allowSelection: true));
          return selectedTemplate;
        },
        onExit: () => Navigator.of(context).pop(),
      ),
    );
