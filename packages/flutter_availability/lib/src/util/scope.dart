import "package:flutter/widgets.dart";
import "package:flutter_availability/src/config/availability_options.dart";
import "package:flutter_availability/src/service/availability_service.dart";

///
class AvailabilityScope extends InheritedWidget {
  ///
  const AvailabilityScope({
    required this.userId,
    required this.options,
    required this.service,
    required super.child,
    super.key,
  });

  ///
  final String userId;

  ///
  final AvailabilityOptions options;

  ///
  final AvailabilityService service;

  @override
  bool updateShouldNotify(AvailabilityScope oldWidget) =>
      oldWidget.userId != userId || options != options;

  ///
  static AvailabilityScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AvailabilityScope>()!;
}
