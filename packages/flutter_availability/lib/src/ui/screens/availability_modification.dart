import "package:flutter/material.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/widgets/availability_clear.dart";
import "package:flutter_availability/src/ui/widgets/availability_template_selection.dart";
import "package:flutter_availability/src/ui/widgets/availabillity_time_selection.dart";
import "package:flutter_availability/src/ui/widgets/pause_selection.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Screen for modifying the availabilities for a specific daterange
/// There might already be availabilities for the selected period but they
/// will be overwritten
class AvailabilitiesModificationScreen extends StatefulWidget {
  /// Constructor
  const AvailabilitiesModificationScreen({
    required this.dateRange,
    required this.onExit,
    required this.initialAvailabilities,
    super.key,
  });

  /// The date for which the availability is being managed
  /// If the daterange is only 1 day the [AvailabilitiesModificationScreen] will
  /// show the layout for a single day otherwise it will show the layout
  /// for a period
  final DateTimeRange dateRange;

  /// The initial availabilities for the selected period
  /// If empty the user will be creating new availabilities
  final List<AvailabilityWithTemplate> initialAvailabilities;

  /// Callback for when the user wants to navigate back or the
  /// availabilities have been saved
  final VoidCallback onExit;

  @override
  State<AvailabilitiesModificationScreen> createState() =>
      _AvailabilitiesModificationScreenState();
}

class _AvailabilitiesModificationScreenState
    extends State<AvailabilitiesModificationScreen> {
  late AvailabilityModel _availability;
  bool _clearAvailability = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _availability =
        widget.initialAvailabilities.getAvailabilities().firstOrNull ??
            AvailabilityModel(
              userId: "",
              startDate: widget.dateRange.start,
              endDate: widget.dateRange.end,
              breaks: [],
            );
  }

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var service = availabilityScope.service;
    var options = availabilityScope.options;
    var spacing = options.spacing;
    var translations = options.translations;

    // TODO(freek): the selected period might be longer than 1 month
    //so we need to get all the availabilites through a stream

    Future<void> onSave() async {
      if (_clearAvailability) {
        await service.clearAvailabilities(
          widget.initialAvailabilities.getAvailabilities(),
        );
        widget.onExit();
        return;
      }
      if (widget.initialAvailabilities.isNotEmpty) {
        await service.clearAvailabilities(
          widget.initialAvailabilities.getAvailabilities(),
        );
      }

      await service.createAvailability(
        availability: _availability,
        range: widget.dateRange,
        startTime: _startTime!,
        endTime: _endTime!,
      );
      widget.onExit();
    }

    var canSave =
        _clearAvailability || (_startTime != null && _endTime != null);
    var saveButton = options.primaryButtonBuilder(
      context,
      canSave ? onSave : null,
      Text(translations.saveButton),
    );

    var clearSection = AvailabilityClearSection(
      range: widget.dateRange,
      clearAvailable: _clearAvailability,
      onChanged: (isChecked) {
        setState(() {
          _clearAvailability = isChecked;
        });
      },
    );

    var templateSelection = const AvailabilityTemplateSelection();

    var timeSelection = AvailabilityTimeSelection(
      dateRange: widget.dateRange,
      startTime: _startTime,
      endTime: _endTime,
      key: ValueKey([_startTime, _endTime]),
      onStartChanged: (start) => setState(() {
        _startTime = start;
      }),
      onEndChanged: (end) => setState(() {
        _endTime = end;
      }),
    );

    var pauseSelection = PauseSelection(
      breaks: _availability.breaks,
      onBreaksChanged: (breaks) {
        setState(() {
          _availability = _availability.copyWith(breaks: breaks);
        });
      },
    );

    var body = CustomScrollView(
      slivers: [
        SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: options.spacing.sidePadding),
          sliver: SliverList.list(
            children: [
              const SizedBox(height: 40),
              clearSection,
              if (!_clearAvailability) ...[
                const SizedBox(height: 24),
                templateSelection,
                const SizedBox(height: 24),
                timeSelection,
                const SizedBox(height: 26),
                pauseSelection,
              ],
            ],
          ),
        ),
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sidePadding,
            ).copyWith(
              bottom: spacing.bottomButtonPadding,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: saveButton,
            ),
          ),
        ),
      ],
    );

    return options.baseScreenBuilder(
      context,
      widget.onExit,
      body,
    );
  }
}
