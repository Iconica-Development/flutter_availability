import "package:flutter/material.dart";
import "package:flutter_availability/src/screens/availability_day_overview.dart";
import "package:flutter_availability/src/screens/availability_overview.dart";
import "package:flutter_availability/src/screens/availability_select.dart";
import "package:flutter_availability/src/service/local_service.dart";
import "package:flutter_availability/src/userstory/userstory_configuration.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
Widget availabilityNavigatorUserStory(
  BuildContext context, {
  AvailabilityUserstoryConfiguration? configuration,
}) =>
    _availabilityScreenRoute(
      context,
      configuration ??
          AvailabilityUserstoryConfiguration(
            service: LocalAvailabilityDataInterface(),
            getUserId: (_) => "no-user",
          ),
    );

Widget _availabilityScreenRoute(
  BuildContext context,
  AvailabilityUserstoryConfiguration configuration,
) =>
    SafeArea(
      child: Scaffold(
        body: AvailabilityOverview(
          service: configuration.service,
          options: configuration.options,
          userId: configuration.getUserId(context),
          onDayClicked: (date) async => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _availabilityDayOverviewRoute(
                context,
                configuration,
                date,
                null,
              ),
            ),
          ),
          onAvailabilityClicked: (availability) async =>
              Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _availabilityDayOverviewRoute(
                context,
                configuration,
                availability.startDate,
                availability,
              ),
            ),
          ),
          onDaysSelected: (selectedDates) async => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _availabilitySelectionOverviewRoute(
                context,
                configuration,
                selectedDates,
              ),
            ),
          ),
        ),
      ),
    );

Widget _availabilityDayOverviewRoute(
  BuildContext context,
  AvailabilityUserstoryConfiguration configuration,
  DateTime date,
  AvailabilityModel? availability,
) =>
    SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: AvailabilityDayOverview(
          service: configuration.service,
          options: configuration.options,
          userId: configuration.getUserId(context),
          date: date,
          initialAvailability: availability,
          onAvailabilitySaved: () => Navigator.of(context).pop(),
        ),
      ),
    );

Widget _availabilitySelectionOverviewRoute(
  BuildContext context,
  AvailabilityUserstoryConfiguration configuration,
  DateTimeRange selectedDates,
) =>
    SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: AvailabilitySelectionScreen(
          selectedDates: selectedDates,
          onTemplateSelectClicked: () async => null,
        ),
      ),
    );
