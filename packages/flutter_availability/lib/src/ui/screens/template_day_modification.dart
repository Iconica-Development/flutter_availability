import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/view_models/day_template_view_model.dart";
import "package:flutter_availability/src/ui/widgets/color_selection.dart";
import "package:flutter_availability/src/ui/widgets/template_name_input.dart";
import "package:flutter_availability/src/ui/widgets/template_time_break.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Page for creating or editing a day template
class DayTemplateModificationScreen extends StatefulWidget {
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
    var spacing = options.spacing;

    Future<void> onDeletePressed() async {
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

    var saveButton = options.primaryButtonBuilder(
      context,
      canSave ? onSavePressed : null,
      Text(translations.saveButton),
    );

    var deleteButton = options.bigTextButtonBuilder(
      context,
      onDeletePressed,
      Text(translations.deleteTemplateButton),
    );

    var title = Center(
      child: Text(
        translations.dayTemplateTitle,
        style: theme.textTheme.displaySmall,
      ),
    );

    var templateTitleSection = TemplateNameInput(
      initialValue: _viewModel.name,
      onNameChanged: (name) {
        setState(() {
          _viewModel = _viewModel.copyWith(name: name);
        });
      },
    );

    var colorSection = TemplateColorSelection(
      selectedColor: _viewModel.color,
      // TODO(Joey): Extract this
      onColorSelected: (color) {
        setState(() {
          _viewModel = _viewModel.copyWith(color: color);
        });
      },
    );

    var availabilitySection = TemplateTimeAndBreakSection(
      dayData: _viewModel.data,
      onDayDataChanged: (data) {
        setState(() {
          _viewModel = _viewModel.copyWith(data: data);
        });
      },
    );

    var body = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: spacing.sidePadding),
          sliver: SliverList.list(
            children: [
              const SizedBox(height: 40),
              title,
              const SizedBox(height: 24),
              templateTitleSection,
              const SizedBox(height: 24),
              availabilitySection,
              const SizedBox(height: 24),
              colorSection,
              const SizedBox(height: 32),
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
              child: Column(
                children: [
                  saveButton,
                  if (widget.template != null) ...[
                    const SizedBox(height: 8),
                    deleteButton,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return options.baseScreenBuilder(context, widget.onExit, body);
  }
}
