import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
class AvailabilityService {
  ///
  const AvailabilityService({
    required this.userId,
    required this.dataInterface,
  });

  ///
  final String userId;

  ///
  final AvailabilityDataInterface dataInterface;
}
