import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/models/view_template_daydata.dart";
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
  late int? _selectedColor;
  late AvailabilityTemplateModel _template;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.template?.color;
    _template = widget.template ??
        AvailabilityTemplateModel(
          userId: "1",
          name: "",
          color: 0,
          templateType: AvailabilityTemplateType.day,
          templateData: DayTemplateData(
            startTime: DateTime.now(),
            endTime: DateTime.now(),
            breaks: [],
          ),
        );
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
      await service.deleteTemplate(_template);
      widget.onExit();
    }

    Future<void> onSavePressed() async {
      if (widget.template == null) {
        await service.createTemplate(_template);
      } else {
        await service.updateTemplate(_template);
      }
      widget.onExit();
    }

    var canSave = _template.name.isNotEmpty && _selectedColor != null;

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
      initialValue: _template.name,
      onNameChanged: (name) {
        setState(() {
          _template = _template.copyWith(name: name);
        });
      },
    );

    var colorSection = TemplateColorSelection(
      selectedColor: _selectedColor,
      // TODO(Joey): Extract this
      onColorSelected: (color) {
        setState(() {
          _selectedColor = color;
          _template = _template.copyWith(color: color);
        });
      },
    );

    var availabilitySection = TemplateTimeAndBreakSection(
      dayData: ViewDayTemplateData.fromDayTemplateData(
        _template.templateData as DayTemplateData,
      ),
      onDayDataChanged: (data) {
        setState(() {
          _template = _template.copyWith(
            templateData: data.toDayTemplateData(),
          );
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
