import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/view_models/day_template_view_model.dart";
import "package:flutter_availability/src/ui/view_models/template_daydata_view_model.dart";
import "package:flutter_availability/src/ui/widgets/base_page.dart";
import "package:flutter_availability/src/ui/widgets/color_selection.dart";
import "package:flutter_availability/src/ui/widgets/template_name_input.dart";
import "package:flutter_availability/src/ui/widgets/template_time_break.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// Page for creating or editing a day template
class DayTemplateModificationScreen extends StatefulHookWidget {
  /// Constructor
  const DayTemplateModificationScreen({
    required this.template,
    required this.onExit,
    super.key,
  });

  /// The day template to edit or null if creating a new one
  final AvailabilityTemplateModel? template;

  /// Callback for when the user wants to navigate back
  final VoidCallback onExit;

  @override
  State<DayTemplateModificationScreen> createState() =>
      _DayTemplateModificationScreenState();
}

class _DayTemplateModificationScreenState
    extends State<DayTemplateModificationScreen> {
  late DayTemplateViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _viewModel = DayTemplateViewModel.fromTemplate(widget.template!);
    } else {
      _viewModel = const DayTemplateViewModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var service = availabilityScope.service;
    var options = availabilityScope.options;
    var translations = options.translations;

    useEffect(() {
      availabilityScope.popHandler.add(widget.onExit);
      return () => availabilityScope.popHandler.remove(widget.onExit);
    });

    Future<void> onDeletePressed() async {
      var isConfirmed = await options.confirmationDialogBuilder(
        context,
        title: translations.templateDeleteDialogConfirmTitle,
        description: translations.templateDeleteDialogConfirmDescription,
      );
      if (!isConfirmed) return;

      await service.deleteTemplate(widget.template!);
      widget.onExit();
    }

    Future<void> onSavePressed() async {
      var template = _viewModel.toTemplate();
      if (widget.template == null) {
        await service.createTemplate(template);
      } else {
        await service.updateTemplate(template);
      }
      widget.onExit();
    }

    var canSave = _viewModel.canSave;

    var deleteButton = options.bigTextButtonBuilder(
      context,
      onDeletePressed,
      Text(translations.deleteTemplateButton),
    );

    void onNameChanged(String name) {
      setState(() {
        _viewModel = _viewModel.copyWith(name: name);
      });
    }

    void onColorSelected(int? color) {
      setState(() {
        _viewModel = _viewModel.copyWith(color: color);
      });
    }

    void onDayDataChanged(DayTemplateDataViewModel data) {
      setState(() {
        _viewModel = _viewModel.copyWith(data: data);
      });
    }

    return options.baseScreenBuilder(
      context,
      widget.onExit,
      BasePage(
        body: [
          Center(
            child: Text(
              translations.dayTemplateTitle,
              style: theme.textTheme.displaySmall,
            ),
          ),
          const SizedBox(height: 24),
          TemplateNameInput(
            initialValue: _viewModel.name,
            onNameChanged: onNameChanged,
          ),
          const SizedBox(height: 24),
          TemplateTimeAndBreakSection(
            dayData: _viewModel.data,
            onDayDataChanged: onDayDataChanged,
          ),
          const SizedBox(height: 24),
          TemplateColorSelection(
            selectedColor: _viewModel.color,
            onColorSelected: onColorSelected,
          ),
        ],
        buttons: [
          options.primaryButtonBuilder(
            context,
            canSave ? onSavePressed : null,
            Text(translations.saveButton),
          ),
          if (widget.template != null) ...[
            const SizedBox(height: 8),
            deleteButton,
          ],
        ],
      ),
    );
  }
}
