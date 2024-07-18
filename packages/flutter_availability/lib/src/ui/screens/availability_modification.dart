import "package:flutter/material.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/view_models/break_view_model.dart";
import "package:flutter_availability/src/ui/widgets/availability_clear.dart";
import "package:flutter_availability/src/ui/widgets/availability_template_selection.dart";
import "package:flutter_availability/src/ui/widgets/availabillity_time_selection.dart";
import "package:flutter_availability/src/ui/widgets/base_page.dart";
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
    required this.onTemplateSelection,
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

  /// Callback for when the user wants to go to the template overview screen to
  /// select a template
  final Future<AvailabilityTemplateModel?> Function() onTemplateSelection;

  @override
  State<AvailabilitiesModificationScreen> createState() =>
      _AvailabilitiesModificationScreenState();
}

class _AvailabilitiesModificationScreenState
    extends State<AvailabilitiesModificationScreen> {
  late AvailabilityModel _availability;
  late List<AvailabilityTemplateModel> _selectedTemplates;
  bool _clearAvailability = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    // TODO(Joey): These can be immediately assigned to the properties
    // This removes the need for an initState
    _availability =
        widget.initialAvailabilities.getAvailabilities().firstOrNull ??
            AvailabilityModel(
              userId: "",
              startDate: widget.dateRange.start,
              endDate: widget.dateRange.end,
              breaks: [],
            );
    _selectedTemplates = widget.initialAvailabilities.getUniqueTemplates();
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

    // TODO(Joey): separate logic from layout to adhere to the single
    // responsibility principle
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

    Future<void> onClickSave() async {
      // TODO(Joey): The name confirmationDialogBuilder does not represent the
      // expected implementation.
      var confirmed = await options.confirmationDialogBuilder(
        context,
        title: translations.availabilityDialogConfirmTitle,
        description: translations.availabilityDialogConfirmDescription,
      );
      // TODO(Joey): We should make the interface of the dialog function return
      // a non nullable bool. Now we are implicitly setting default behaviour
      if (confirmed ?? false) {
        await onSave();
      }
    }

    var canSave =
        _clearAvailability || (_startTime != null && _endTime != null);
    var saveButton = options.primaryButtonBuilder(
      context,
      canSave ? onClickSave : null,
      Text(translations.saveButton),
    );

    // ignore: avoid_positional_boolean_parameters
    void onClearSection(bool isChecked) {
      setState(() {
        _clearAvailability = isChecked;
      });
    }

    Future<void> onTemplateSelected() async {
      var template = await widget.onTemplateSelection();
      if (template != null) {
        setState(() {
          _selectedTemplates = [template];
        });
      }
    }

    void onTemplatesRemoved() {
      setState(() {
        _selectedTemplates = [];
      });
    }

    void onStartChanged(TimeOfDay start) {
      setState(() {
        _startTime = start;
      });
    }

    void onEndChanged(TimeOfDay end) {
      setState(() {
        _endTime = end;
      });
    }

    void onBreaksChanged(List<BreakViewModel> breaks) {
      setState(() {
        _availability = _availability.copyWith(
          breaks: breaks.map((b) => b.toBreak()).toList(),
        );
      });
    }

    return _AvailabilitiesModificationScreenLayout(
      dateRange: widget.dateRange,
      clearAvailability: _clearAvailability,
      onClearSection: onClearSection,
      selectedTemplates: _selectedTemplates,
      onTemplateSelected: onTemplateSelected,
      onTemplatesRemoved: onTemplatesRemoved,
      startTime: _startTime,
      endTime: _endTime,
      onStartChanged: onStartChanged,
      onEndChanged: onEndChanged,
      breaks: _availability.breaks
          .map(BreakViewModel.fromAvailabilityBreakModel)
          .toList(),
      onBreaksChanged: onBreaksChanged,
      sidePadding: spacing.sidePadding,
      bottomButtonPadding: spacing.bottomButtonPadding,
      saveButton: saveButton,
      onExit: widget.onExit,
    );
  }
}

class _AvailabilitiesModificationScreenLayout extends StatelessWidget {
  const _AvailabilitiesModificationScreenLayout({
    required this.dateRange,
    required this.clearAvailability,
    required this.onClearSection,
    required this.selectedTemplates,
    required this.onTemplateSelected,
    required this.onTemplatesRemoved,
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.breaks,
    required this.onBreaksChanged,
    required this.sidePadding,
    required this.bottomButtonPadding,
    required this.saveButton,
    required this.onExit,
  });

  final DateTimeRange dateRange;
  final bool clearAvailability;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool isChecked) onClearSection;

  final List<AvailabilityTemplateModel> selectedTemplates;
  final void Function() onTemplateSelected;
  final void Function() onTemplatesRemoved;

  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final void Function(TimeOfDay start) onStartChanged;
  final void Function(TimeOfDay start) onEndChanged;

  final List<BreakViewModel> breaks;
  final void Function(List<BreakViewModel> breaks) onBreaksChanged;

  final double sidePadding;
  final double bottomButtonPadding;

  final Widget saveButton;

  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;

    return options.baseScreenBuilder(
      context,
      onExit,
      BasePage(
        body: [
          AvailabilityClearSection(
            range: dateRange,
            clearAvailable: clearAvailability,
            onChanged: onClearSection,
          ),
          if (!clearAvailability) ...[
            const SizedBox(height: 24),
            AvailabilityTemplateSelection(
              selectedTemplates: selectedTemplates,
              onTemplateAdd: onTemplateSelected,
              onTemplatesRemoved: onTemplatesRemoved,
            ),
            const SizedBox(height: 24),
            AvailabilityTimeSelection(
              dateRange: dateRange,
              startTime: startTime,
              endTime: endTime,
              key: ValueKey([startTime, endTime]),
              onStartChanged: onStartChanged,
              onEndChanged: onEndChanged,
            ),
            const SizedBox(height: 24),
            PauseSelection(
              breaks: breaks,
              editingTemplate: false,
              onBreaksChanged: onBreaksChanged,
            ),
          ],
        ],
        buttons: [saveButton],
      ),
    );
  }
}
