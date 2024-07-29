import "package:flutter/widgets.dart";
import "package:flutter_availability/src/config/availability_options.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/service/pop_handler.dart";

///
class AvailabilityScope extends InheritedWidget {
  ///
  const AvailabilityScope({
    required this.userId,
    required this.options,
    required this.service,
    required this.popHandler,
    required super.child,
    super.key,
  });

  ///
  final String userId;

  ///
  final AvailabilityOptions options;

  ///
  final AvailabilityService service;

  ///
  final PopHandler popHandler;

  @override
  bool updateShouldNotify(AvailabilityScope oldWidget) =>
      oldWidget.userId != userId || options != options;

  ///
  static AvailabilityScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AvailabilityScope>()!;
}
