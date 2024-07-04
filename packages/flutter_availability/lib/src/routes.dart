import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/ui/screens/template_availability_day_overview.dart";

///
final homePageRoute = MaterialPageRoute(
  builder: (context) => AvailabilityOverview(
    onBack: () => Navigator.of(context).pop(),
    onEditDateRange: (range) {
      Navigator.of(context).push(availabilityViewRoute(range.start));
    },
    onViewTemplates: () {},
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
