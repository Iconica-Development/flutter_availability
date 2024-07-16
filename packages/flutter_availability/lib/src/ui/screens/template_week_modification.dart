import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/models/view_template_daydata.dart";
import "package:flutter_availability/src/ui/widgets/color_selection.dart";
import "package:flutter_availability/src/ui/widgets/template_name_input.dart";
import "package:flutter_availability/src/ui/widgets/template_time_break.dart";
import "package:flutter_availability/src/ui/widgets/template_week_day_selection.dart";
import "package:flutter_availability/src/ui/widgets/template_week_overview.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Page for creating or editing a day template
class WeekTemplateModificationScreen extends StatefulWidget {
  /// Constructor
  const WeekTemplateModificationScreen({
    required this.template,
    required this.onExit,
    super.key,
  });

  /// The week template to edit or null if creating a new one
  final AvailabilityTemplateModel? template;

  /// Callback for when the user wants to navigate back
  final VoidCallback onExit;

  @override
  State<WeekTemplateModificationScreen> createState() =>
      _WeekTemplateModificationScreenState();
}

class _WeekTemplateModificationScreenState
    extends State<WeekTemplateModificationScreen> {
  late int? _selectedColor;
  late AvailabilityTemplateModel _template;
  bool _editing = true;
  WeekDay _selectedDay = WeekDay.monday;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.template?.color;
    _template = widget.template ??
        AvailabilityTemplateModel(
          userId: "1",
          name: "",
          color: 0,
          templateType: AvailabilityTemplateType.week,
          templateData: WeekTemplateData.forDays(),
        );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var service = availabilityScope.service;
    var options = availabilityScope.options;
    var translations = options.translations;
    var spacing = options.spacing;

    var weekTemplateDate = _template.templateData as WeekTemplateData;
    var selectedDayData = weekTemplateDate.data[_selectedDay];

    Future<void> onDeletePressed() async {
      await service.deleteTemplate(_template);
      widget.onExit();
    }

    void onNextPressed() {
      setState(() {
        _editing = false;
      });
    }

    void onBackPressed() {
      if (_editing) {
        widget.onExit();
      } else {
        setState(() {
          _editing = true;
        });
      }
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
    var nextButton = options.primaryButtonBuilder(
      context,
      canSave ? onNextPressed : null,
      Text(translations.nextButton),
    );

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

    var previousButton = options.bigTextButtonBuilder(
      context,
      onBackPressed,
      Text(translations.editTemplateButton),
    );

    var title = Center(
      child: Text(
        translations.weekTemplateTitle,
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
      onColorSelected: (color) {
        setState(() {
          _selectedColor = color;
          _template = _template.copyWith(color: color);
        });
      },
    );

    var editPage = [
      _WeekTemplateSidePadding(child: templateTitleSection),
      const SizedBox(height: 24),
      Padding(
        padding: EdgeInsets.only(left: spacing.sidePadding),
        child: TemplateWeekDaySelection(
          onDaySelected: (day) {
            setState(() {
              _selectedDay = WeekDay.values[day];
            });
          },
        ),
      ),
      const SizedBox(height: 24),
      _WeekTemplateSidePadding(
        child: TemplateTimeAndBreakSection(
          dayData: selectedDayData != null
              ? ViewDayTemplateData.fromDayTemplateData(
                  selectedDayData,
                )
              : const ViewDayTemplateData(),
          onDayDataChanged: (data) {
            setState(() {
              _template = _template.copyWith(
                templateData:
                    // create a copy of the week template data
                    WeekTemplateData(
                  data: {
                    for (var entry in weekTemplateDate.data.entries)
                      entry.key: entry.value,
                    _selectedDay: data.toDayTemplateData(),
                  },
                ),
              );
            });
          },
        ),
      ),
      const SizedBox(height: 24),
      _WeekTemplateSidePadding(child: colorSection),
    ];

    var overviewPage = _WeekTemplateSidePadding(
      child: Column(
        children: [
          Text(translations.templateTitleLabel, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(_template.color),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 12),
                Text(_template.name, style: textTheme.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: 30),
          TemplateWeekOverview(
            template: _template,
          ),
        ],
      ),
    );

    var body = CustomScrollView(
      slivers: [
        SliverList.list(
          children: [
            const SizedBox(height: 40),
            _WeekTemplateSidePadding(child: title),
            const SizedBox(height: 24),
            if (_editing) ...[
              ...editPage,
            ] else ...[
              overviewPage,
            ],
            const SizedBox(height: 32),
          ],
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_editing) ...[
                    nextButton,
                  ] else ...[
                    saveButton,
                    const SizedBox(height: 8),
                    previousButton,
                  ],
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

    return options.baseScreenBuilder(context, onBackPressed, body);
  }
}

/// One of the elements in the week template modification screen doesn't have a
/// padding around it that is why all the other elements are wrapped in
/// [_WeekTemplateSidePadding]
class _WeekTemplateSidePadding extends StatelessWidget {
  const _WeekTemplateSidePadding({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var sidePadding = availabilityScope.options.spacing.sidePadding;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: child,
    );
  }
}
