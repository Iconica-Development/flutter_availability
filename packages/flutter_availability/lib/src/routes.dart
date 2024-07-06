import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/ui/screens/template_availability_day_overview.dart";

///
MaterialPageRoute homePageRoute(VoidCallback onExit) => MaterialPageRoute(
      builder: (context) => AvailabilityOverview(
        onEditDateRange: (range) async {
          await Navigator.of(context).push(availabilityViewRoute(range.start));
        },
        onViewTemplates: () {},
        onExit: () {
          onExit();
        },
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
