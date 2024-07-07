import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/ui/screens/template_availability_day_overview.dart";
import "package:flutter_availability/src/ui/screens/template_day_edit.dart";
import "package:flutter_availability/src/ui/screens/template_overview.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
MaterialPageRoute homePageRoute(VoidCallback onExit) => MaterialPageRoute(
      builder: (context) => AvailabilityOverview(
        onEditDateRange: (range) async =>
            Navigator.of(context).push(availabilityViewRoute(range.start)),
        onViewTemplates: () async =>
            Navigator.of(context).push(templateOverviewRoute()),
        onExit: () => onExit(),
      ),
    );

///
MaterialPageRoute templateOverviewRoute() => MaterialPageRoute(
      builder: (context) => AvailabilityTemplateOverview(
        onExit: () => Navigator.of(context).pop(),
        onEditTemplate: (template) async {
          if (template.templateType == AvailabilityTemplateType.day) {
            await Navigator.of(context).push(templateEditDayRoute(template));
          }
        },
        onAddTemplate: (type) async {
          if (type == AvailabilityTemplateType.day) {
            await Navigator.of(context).push(templateEditDayRoute(null));
          }
        },
      ),
    );

///
MaterialPageRoute templateEditDayRoute(AvailabilityTemplateModel? template) =>
    MaterialPageRoute(
      builder: (context) => AvailabilityDayTemplateEdit(
        template: template,
        onExit: () => Navigator.of(context).pop(),
      ),
    );

///
MaterialPageRoute availabilityViewRoute(
  DateTime date,
) =>
    MaterialPageRoute(
      builder: (context) => AvailabilityDayOverview(
        date: date,
        onAvailabilitySaved: () {
          Navigator.of(context).pop();
        },
      ),
    );
