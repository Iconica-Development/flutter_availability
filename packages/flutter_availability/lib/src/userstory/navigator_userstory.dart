import "package:flutter/material.dart";
import "package:flutter_availability/src/screens/availability_day_overview.dart";
import "package:flutter_availability/src/screens/availability_overview.dart";
import "package:flutter_availability/src/service/local_service.dart";
import "package:flutter_availability/src/userstory/userstory_configuration.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
Widget availabilityNavigatorUserStory(
  BuildContext context, {
  AvailabiltyUserstoryConfiguration? configuration,
}) =>
    _availabiltyScreenRoute(
      context,
      configuration ??
          AvailabiltyUserstoryConfiguration(
            service: LocalAvailabilityDataInterface(),
            getUserId: (_) => "no-user",
          ),
    );

Widget _availabiltyScreenRoute(
  BuildContext context,
  AvailabiltyUserstoryConfiguration configuration,
) =>
    SafeArea(
      child: Scaffold(
        body: AvailabilityOverview(
          service: configuration.service,
          options: configuration.options,
          userId: configuration.getUserId(context),
          onDayClicked: (date) async => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _avaibiltyDayOverviewRoute(
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
              builder: (context) => _avaibiltyDayOverviewRoute(
                context,
                configuration,
                availability.startDate,
                availability,
              ),
            ),
          ),
        ),
      ),
    );

Widget _avaibiltyDayOverviewRoute(
  BuildContext context,
  AvailabiltyUserstoryConfiguration configuration,
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
