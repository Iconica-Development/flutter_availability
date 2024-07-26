import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/view_models/availability_view_model.dart";
import "package:flutter_availability/src/ui/view_models/break_view_model.dart";
import "package:flutter_availability/src/ui/widgets/availability_clear.dart";
import "package:flutter_availability/src/ui/widgets/availability_template_selection.dart";
import "package:flutter_availability/src/ui/widgets/availabillity_time_selection.dart";
import "package:flutter_availability/src/ui/widgets/base_page.dart";
import "package:flutter_availability/src/ui/widgets/pause_selection.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// Screen for modifying the availabilities for a specific daterange
/// There might already be availabilities for the selected period but they
/// will be overwritten
class AvailabilitiesModificationScreen extends StatefulHookWidget {
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
  late AvailabilityViewModel _availabilityViewModel =
      AvailabilityViewModel.fromModel(
    widget.initialAvailabilities,
    widget.dateRange,
  );

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var service = availabilityScope.service;
    var options = availabilityScope.options;
    var spacing = options.spacing;
    var translations = options.translations;

    useEffect(() {
      availabilityScope.popHandler.add(widget.onExit);
      return () => availabilityScope.popHandler.remove(widget.onExit);
    });

    // TODO(freek): the selected period might be longer than 1 month
    //so we need to get all the availabilites through a stream
    Future<void> onSave() async {
      if (_availabilityViewModel.clearAvailability) {
        await service.clearAvailabilities(
          widget.initialAvailabilities.getAvailabilities(),
        );
        widget.onExit();
        return;
      }

      AvailabilityError? error;
      try {
        if (_availabilityViewModel.templateSelected) {
          await service.applyTemplate(
            template: _availabilityViewModel.templates.first,
            range: widget.dateRange,
          );
        } else {
          await service.createAvailability(
            availability: _availabilityViewModel.toModel(),
            range: widget.dateRange,
          );
        }
        widget.onExit();
      } on AvailabilityEndBeforeStartException {
        error = AvailabilityError.endBeforeStart;
      } on BreakEndBeforeStartException {
        error = AvailabilityError.breakEndBeforeStart;
      } on BreakSubmittedDurationTooLongException {
        error = AvailabilityError.breakSubmittedDurationTooLong;
      }

      if (error != null && context.mounted) {
        await options.errorDisplayBuilder(
          context,
          error,
        );
      }
    }

    Future<void> onClickSave() async {
      // TODO(Joey): The name confirmationDialogBuilder does not represent the
      // expected implementation.
      var isConfirmed = await options.confirmationDialogBuilder(
        context,
        title: translations.availabilityDialogConfirmTitle,
        description: translations.availabilityDialogConfirmDescription,
      );

      if (isConfirmed) {
        await onSave();
      }
    }

    var canSave = _availabilityViewModel.canSave;
    var saveButton = options.primaryButtonBuilder(
      context,
      canSave ? onClickSave : null,
      Text(translations.saveButton),
    );

    // ignore: avoid_positional_boolean_parameters
    void onClearSection(bool isChecked) {
      setState(() {
        _availabilityViewModel = _availabilityViewModel.copyWith(
          clearAvailability: isChecked,
        );
      });
    }

    Future<void> onTemplateSelected() async {
      var template = await widget.onTemplateSelection();
      if (template != null) {
        setState(() {
          _availabilityViewModel =
              _availabilityViewModel.applyTemplate(template);
        });
      }
    }

    void onTemplatesRemoved() {
      setState(() {
        _availabilityViewModel = _availabilityViewModel.removeTemplates();
      });
    }

    void onStartChanged(TimeOfDay start) {
      setState(() {
        _availabilityViewModel = _availabilityViewModel.copyWith(
          startTime: start,
          templateSelected: false,
        );
      });
    }

    void onEndChanged(TimeOfDay end) {
      setState(() {
        _availabilityViewModel = _availabilityViewModel.copyWith(
          endTime: end,
          templateSelected: false,
        );
      });
    }

    void onBreaksChanged(List<BreakViewModel> breaks) {
      setState(() {
        _availabilityViewModel = _availabilityViewModel.copyWith(
          breaks: breaks,
          templateSelected: false,
        );
      });
    }

    return _AvailabilitiesModificationScreenLayout(
      viewModel: _availabilityViewModel,
      onClearSection: onClearSection,
      selectedTemplates: _availabilityViewModel.templates,
      onTemplateSelected: onTemplateSelected,
      onTemplatesRemoved: onTemplatesRemoved,
      onStartChanged: onStartChanged,
      onEndChanged: onEndChanged,
      onBreaksChanged: onBreaksChanged,
      sidePadding: spacing.sidePadding,
      bottomButtonPadding: spacing.bottomButtonPadding,
      saveButton: saveButton,
      onExit: widget.onExit,
    );
  }
}

class _AvailabilitiesModificationScreenLayout extends HookWidget {
  const _AvailabilitiesModificationScreenLayout({
    required this.viewModel,
    required this.onClearSection,
    required this.selectedTemplates,
    required this.onTemplateSelected,
    required this.onTemplatesRemoved,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.onBreaksChanged,
    required this.sidePadding,
    required this.bottomButtonPadding,
    required this.saveButton,
    required this.onExit,
  });

  final AvailabilityViewModel viewModel;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool isChecked) onClearSection;

  final List<AvailabilityTemplateModel> selectedTemplates;
  final void Function() onTemplateSelected;
  final void Function() onTemplatesRemoved;

  final void Function(TimeOfDay start) onStartChanged;
  final void Function(TimeOfDay start) onEndChanged;

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
            range: viewModel.selectedRange,
            clearAvailable: viewModel.clearAvailability,
            onChanged: onClearSection,
          ),
          if (!viewModel.clearAvailability) ...[
            const SizedBox(height: 24),
            AvailabilityTemplateSelection(
              selectedTemplates: selectedTemplates,
              onTemplateAdd: onTemplateSelected,
              onTemplatesRemoved: onTemplatesRemoved,
            ),
            const SizedBox(height: 24),
            AvailabilityTimeSelection(
              viewModel: viewModel,
              key: ValueKey(viewModel),
              onStartChanged: onStartChanged,
              onEndChanged: onEndChanged,
            ),
            const SizedBox(height: 24),
            PauseSelection(
              breaks: viewModel.breaks,
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
