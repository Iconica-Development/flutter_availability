import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_options.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
class AvailabilityUserstoryConfiguration {
  ///
  const AvailabilityUserstoryConfiguration({
    required this.service,
    required this.getUserId,
    this.options = const AvailabilityOptions(),
  });

  ///
  final AvailabilityOptions options;

  ///
  final AvailabilityDataInterface service;

  ///
  final Function(BuildContext context) getUserId;
}
