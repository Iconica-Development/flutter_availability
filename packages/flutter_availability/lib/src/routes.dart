import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/ui/screens/template_availability_day_overview.dart";
import "package:flutter_availability/src/ui/screens/template_overview.dart";

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
        onEditTemplate: (template) {},
        onAddTemplate: (type) {},
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
