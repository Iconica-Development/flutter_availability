import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_options.dart";
import "package:flutter_availability/src/routes.dart";
import "package:flutter_availability/src/service/pop_handler.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// This pushes the availability user story to the navigator stack.
Future<void> openAvailabilitiesForUser(
  BuildContext context,
  String userId,
  AvailabilityOptions? options,
) async {
  var navigator = Navigator.of(context);

  await navigator.push(
    AvailabilityUserStory.route(
      userId,
      options ?? AvailabilityOptions(),
    ),
  );
}

///
class AvailabilityUserStory extends StatefulWidget {
  ///
  const AvailabilityUserStory({
    required this.userId,
    required this.options,
    this.onExit,
    super.key,
  });

  ///
  final String userId;

  ///
  final AvailabilityOptions options;

  /// Callback for when the user wants to navigate back
  final VoidCallback? onExit;

  ///
  static MaterialPageRoute route(String userId, AvailabilityOptions options) =>
      MaterialPageRoute(
        builder: (context) => AvailabilityUserStory(
          userId: userId,
          options: options,
        ),
      );

  @override
  State<AvailabilityUserStory> createState() => _AvailabilityUserStoryState();
}

class _AvailabilityUserStoryState extends State<AvailabilityUserStory> {
  late AvailabilityService _service = AvailabilityService(
    userId: widget.userId,
    dataInterface: widget.options.dataInterface,
  );

  late final PopHandler _popHandler = PopHandler();

  @override
  Widget build(BuildContext context) => AvailabilityScope(
        userId: widget.userId,
        options: widget.options,
        service: _service,
        popHandler: _popHandler,
        child: NavigatorPopHandler(
          onPop: _popHandler.handlePop,
          child: Navigator(
            onGenerateInitialRoutes: (state, route) => [
              homePageRoute(widget.onExit ?? () {}),
            ],
          ),
        ),
      );

  @override
  void didUpdateWidget(covariant AvailabilityUserStory oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.userId != widget.userId ||
        oldWidget.options != widget.options) {
      setState(() {
        _service = AvailabilityService(
          userId: widget.userId,
          dataInterface: widget.options.dataInterface,
        );
      });
    }
  }
}
