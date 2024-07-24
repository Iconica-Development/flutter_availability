import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/view_models/break_view_model.dart";
import "package:flutter_availability/src/ui/widgets/generic_time_selection.dart";
import "package:flutter_availability/src/ui/widgets/input_fields.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class PauseSelection extends StatelessWidget {
  ///
  const PauseSelection({
    required this.breaks,
    required this.onBreaksChanged,
    required this.editingTemplate,
    super.key,
  });

  /// The breaks that are currently set
  final List<BreakViewModel> breaks;

  /// Callback for when the breaks are changed
  final void Function(List<BreakViewModel>) onBreaksChanged;

  /// Whether the pause selection is used for editing a template
  final bool editingTemplate;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    Future<BreakViewModel?> openBreakDialog(
      BreakViewModel? initialBreak,
    ) async {
      FocusManager.instance.primaryFocus?.unfocus();
      return AvailabilityBreakSelectionDialog.show(
        context,
        initialBreak: initialBreak,
        userId: availabilityScope.userId,
        options: options,
        service: availabilityScope.service,
        editingTemplate: editingTemplate,
      );
    }

    Future<void> onClickAddBreak() async {
      var newBreak = await openBreakDialog(null);
      if (newBreak == null) return;

      var updatedBreaks = [...breaks, newBreak];
      onBreaksChanged(updatedBreaks);
    }

    Future<void> onEditBreak(BreakViewModel availabilityBreak) async {
      var updatedBreak = await openBreakDialog(availabilityBreak);
      if (updatedBreak == null) return;
      // remove the old break and add the updated one
      var updatedBreaks = [...breaks, updatedBreak];
      updatedBreaks.remove(availabilityBreak);
      onBreaksChanged(updatedBreaks);
    }

    void onDeleteBreak(BreakViewModel availabilityBreak) {
      var updatedBreaks = breaks.where((b) => b != availabilityBreak).toList();
      onBreaksChanged(updatedBreaks);
    }

    var sortedBreaks = breaks.toList()..sort((a, b) => a.compareTo(b));

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
  final BreakViewModel breakModel;

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
      breakModel.startTime!,
    );
    var endTime = translations.timeFormatter(
      context,
      breakModel.endTime!,
    );

    var breakDuration = breakModel.duration.inMinutes;

    return InkWell(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: colors.selectedDayColor,
          border: Border.all(color: theme.colorScheme.primary, width: 1),
          borderRadius: options.borderRadius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              "$breakDuration "
              "${translations.timeMinutes}  |  "
              "$starTime - "
              "$endTime",
            ),
            const Spacer(),
            InkWell(
              onTap: onRemove,
              child: const Icon(Icons.remove),
            ),
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
    required this.editingTemplate,
    super.key,
  });

  /// The initial break to show in the dialog if any
  final BreakViewModel? initialBreak;

  /// Whether the dialog is used to edit a template
  /// This will change the description of the dialog
  final bool editingTemplate;

  /// Opens the dialog to add a break
  static Future<BreakViewModel?> show(
    BuildContext context, {
    required AvailabilityOptions options,
    required String userId,
    required AvailabilityService service,
    required bool editingTemplate,
    BreakViewModel? initialBreak,
  }) async =>
      showModalBottomSheet<BreakViewModel>(
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
            editingTemplate: editingTemplate,
          ),
        ),
      );

  @override
  State<AvailabilityBreakSelectionDialog> createState() =>
      _AvailabilityBreakSelectionDialogState();
}

class _AvailabilityBreakSelectionDialogState
    extends State<AvailabilityBreakSelectionDialog> {
  late BreakViewModel _breakViewModel;

  @override
  void initState() {
    super.initState();
    _breakViewModel = widget.initialBreak ?? const BreakViewModel();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;
    var spacing = options.spacing;

    void onUpdateDuration(Duration? duration) {
      setState(() {
        if (duration != null) {
          _breakViewModel =
              _breakViewModel.copyWith(submittedDuration: duration);
        } else {
          _breakViewModel = _breakViewModel.clearDuration();
        }
      });
    }

    void onUpdateStart(TimeOfDay start) {
      setState(() {
        _breakViewModel = _breakViewModel.copyWith(startTime: start);
      });
    }

    void onUpdateEnd(TimeOfDay end) {
      setState(() {
        _breakViewModel = _breakViewModel.copyWith(endTime: end);
      });
    }

    var canSave = _breakViewModel.canSave;

    var onSaveButtonPress = canSave
        ? () {
            if (_breakViewModel.isValid) {
              Navigator.of(context).pop(_breakViewModel);
            } else {
              debugPrint("Break is not valid");
              // TODO(freek): show error message
            }
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

    var descriptionText = widget.editingTemplate
        ? translations.pauseDialogDescriptionTemplate
        : translations.pauseDialogDescriptionAvailability;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: spacing.sidePadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 44),
                Text(
                  translations.pauseDialogTitle,
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  descriptionText,
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: DurationInputField(
                        initialValue: _breakViewModel.submittedDuration,
                        onDurationChanged: onUpdateDuration,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 24),
                TimeSelection(
                  key: ValueKey(
                    [_breakViewModel.startTime, _breakViewModel.endTime],
                  ),
                  // rebuild the widget when the start or end time changes
                  title: translations.pauseDialogPeriodTitle,
                  description: translations.pauseDialogPeriodDescription,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  startTime: _breakViewModel.startTime,
                  endTime: _breakViewModel.endTime,
                  onStartChanged: onUpdateStart,
                  onEndChanged: onUpdateEnd,
                ),
                const SizedBox(height: 36),
                saveButton,
                SizedBox(height: spacing.bottomButtonPadding),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            padding: const EdgeInsets.all(16),
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
