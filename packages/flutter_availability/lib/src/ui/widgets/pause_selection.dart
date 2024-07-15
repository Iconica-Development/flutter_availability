import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/widgets/generic_time_selection.dart";
import "package:flutter_availability/src/ui/widgets/input_fields.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
class PauseSelection extends StatelessWidget {
  ///
  const PauseSelection({
    required this.breaks,
    required this.onBreaksChanged,
    super.key,
  });

  /// The breaks that are currently set
  final List<AvailabilityBreakModel> breaks;

  /// Callback for when the breaks are changed
  final void Function(List<AvailabilityBreakModel>) onBreaksChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    Future<AvailabilityBreakModel?> openBreakDialog(
      AvailabilityBreakModel? initialBreak,
    ) async =>
        AvailabilityBreakSelectionDialog.show(
          context,
          userId: availabilityScope.userId,
          options: options,
          service: availabilityScope.service,
        );

    Future<void> onClickAddBreak() async {
      var newBreak = await openBreakDialog(null);
      if (newBreak == null) return;

      var updatedBreaks = [...breaks, newBreak];
      onBreaksChanged(updatedBreaks);
    }

    Future<void> onEditBreak(AvailabilityBreakModel availabilityBreak) async {
      var updatedBreak = await openBreakDialog(availabilityBreak);
      if (updatedBreak == null) return;

      var updatedBreaks = [...breaks, updatedBreak];
      onBreaksChanged(updatedBreaks);
    }

    void onDeleteBreak(AvailabilityBreakModel availabilityBreak) {
      var updatedBreaks = breaks.where((b) => b != availabilityBreak).toList();
      onBreaksChanged(updatedBreaks);
    }

    var sortedBreaks = breaks.toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    var addButton = options.bigTextButtonWrapperBuilder(
      context,
      onClickAddBreak,
      options.bigTextButtonBuilder(
        context,
        onClickAddBreak,
        Text(translations.addButton),
      ),
    );

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translations.pauseSectionTitle,
              style: textTheme.titleMedium,
            ),
            const SizedBox(width: 4),
            Text(
              translations.pauseSectionOptional,
              style: textTheme.bodyLarge,
            ),
          ],
        ),
        for (var breakModel in sortedBreaks) ...[
          const SizedBox(height: 8),
          BreakDisplay(
            breakModel: breakModel,
            onRemove: () => onDeleteBreak(breakModel),
            onClick: () async => onEditBreak(breakModel),
          ),
        ],
        const SizedBox(height: 8),
        addButton,
      ],
    );
  }
}

/// Displays a single break with buttons to edit or delete it
class BreakDisplay extends StatelessWidget {
  /// Creates a new break display
  const BreakDisplay({
    required this.breakModel,
    required this.onRemove,
    required this.onClick,
    super.key,
  });

  /// The break to display
  final AvailabilityBreakModel breakModel;

  /// Callback for when the minus button is clicked
  final VoidCallback onRemove;

  /// Callback for when the break is clicked except for the minus button
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var colors = options.colors;
    var translations = options.translations;

    var starTime = translations.timeFormatter(
      context,
      TimeOfDay.fromDateTime(breakModel.startTime),
    );
    var endTime = translations.timeFormatter(
      context,
      TimeOfDay.fromDateTime(breakModel.endTime),
    );

    // TODO(Joey): Watch out with gesture detectors
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: colors.selectedDayColor,
          border: Border.all(color: theme.colorScheme.primary, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              "${breakModel.duration.inMinutes} "
              "${translations.timeMinutes}  |  "
              "$starTime - "
              "$endTime",
            ),
            const Spacer(),
            // TODO(Joey): Watch out with gesturedetectors
            GestureDetector(onTap: onRemove, child: const Icon(Icons.remove)),
          ],
        ),
      ),
    );
  }
}

///
class AvailabilityBreakSelectionDialog extends StatefulWidget {
  ///
  const AvailabilityBreakSelectionDialog({
    required this.initialBreak,
    super.key,
  });

  /// The initial break to show in the dialog if any
  final AvailabilityBreakModel? initialBreak;

  /// Opens the dialog to add a break
  static Future<AvailabilityBreakModel?> show(
    BuildContext context, {
    required AvailabilityOptions options,
    required String userId,
    required AvailabilityService service,
    AvailabilityBreakModel? initialBreak,
  }) async =>
      showModalBottomSheet<AvailabilityBreakModel>(
        context: context,
        useSafeArea: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        builder: (context) => AvailabilityScope(
          userId: userId,
          options: options,
          service: service,
          child: AvailabilityBreakSelectionDialog(
            initialBreak: initialBreak,
          ),
        ),
      );

  @override
  State<AvailabilityBreakSelectionDialog> createState() =>
      _AvailabilityBreakSelectionDialogState();
}

class _AvailabilityBreakSelectionDialogState
    extends State<AvailabilityBreakSelectionDialog> {
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;
  late Duration? _duration;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialBreak != null
        ? TimeOfDay.fromDateTime(widget.initialBreak!.startTime)
        : null;
    _endTime = widget.initialBreak != null
        ? TimeOfDay.fromDateTime(widget.initialBreak!.endTime)
        : null;
    _duration = widget.initialBreak?.duration;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;
    var spacing = options.spacing;

    void onUpdateDuration(Duration duration) {
      setState(() {
        _duration = duration;
      });
    }

    void onUpdateStart(TimeOfDay start) {
      setState(() {
        _startTime = start;
      });
    }

    void onUpdateEnd(TimeOfDay end) {
      setState(() {
        _endTime = end;
      });
    }

    var canSave = _startTime != null && _endTime != null;

    var onSaveButtonPress = canSave
        ? () {
            var breakModel = AvailabilityBreakModel(
              startTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _startTime!.hour,
                _startTime!.minute,
              ),
              endTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _endTime!.hour,
                _endTime!.minute,
              ),
              duration: _duration,
            );
            Navigator.of(context).pop(breakModel);
          }
        : null;

    var saveButton = options.primaryButtonBuilder(
      context,
      onSaveButtonPress,
      Text(
        widget.initialBreak == null
            ? translations.addButton
            : translations.saveButton,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: spacing.sidePadding,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 44),
            Text(translations.pauseDialogTitle, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              translations.pauseDialogDescription,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: DurationInputField(
                    initialValue: _duration,
                    onDurationChanged: onUpdateDuration,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 24),
            TimeSelection(
              // rebuild the widget when the start or end time changes
              key: ValueKey([_startTime, _endTime]),
              title: translations.pauseDialogPeriodTitle,
              description: translations.pauseDialogPeriodDescription,
              crossAxisAlignment: CrossAxisAlignment.center,
              startTime: _startTime,
              endTime: _endTime,
              onStartChanged: onUpdateStart,
              onEndChanged: onUpdateEnd,
            ),
            const SizedBox(height: 36),
            saveButton,
            SizedBox(height: spacing.bottomButtonPadding),
          ],
        ),
      ),
    );
  }
}
