import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:mocktail/mocktail.dart";

class DataInterfaceMock extends Mock implements AvailabilityDataInterface {}

class MockTemplate extends Mock implements AvailabilityTemplateModel {}

class MockAvailability extends Mock implements AvailabilityModel {}
