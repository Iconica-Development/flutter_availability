import "package:flutter/material.dart";
import "package:flutter_availability/src/service/errors.dart";
import "package:flutter_availability/src/ui/view_models/template_daydata_view_model.dart";
import "package:flutter_availability/src/ui/view_models/week_template_view_models.dart";
import "package:flutter_availability/src/ui/widgets/color_selection.dart";
import "package:flutter_availability/src/ui/widgets/template_name_input.dart";
import "package:flutter_availability/src/ui/widgets/template_time_break.dart";
import "package:flutter_availability/src/ui/widgets/template_week_day_selection.dart";
import "package:flutter_availability/src/ui/widgets/template_week_overview.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// Page for creating or editing a day template
class WeekTemplateModificationScreen extends StatefulHookWidget {
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
  bool _editing = true;
  WeekDay _selectedDay = WeekDay.monday;
  late WeekTemplateViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.template != null
        ? WeekTemplateViewModel.fromTemplate(widget.template!)
        : const WeekTemplateViewModel();
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

    var weekTemplateDate = _viewModel.data;
    var selectedDayData = weekTemplateDate[_selectedDay];

    void onDayDataChanged(DayTemplateDataViewModel data) {
      setState(() {
        // create a new copy of an unmodifiable map that can be modified
        var updatedDays =
            Map<WeekDay, DayTemplateDataViewModel>.from(weekTemplateDate);
        if (data.isEmpty) {
          updatedDays.remove(_selectedDay);
        } else {
          updatedDays[_selectedDay] = data;
        }
        _viewModel = _viewModel.copyWith(data: updatedDays);
      });
    }

    void onDaySelected(int day) {
      setState(() {
        _selectedDay = WeekDay.values[day];
      });
    }

    Future<void> onDeletePressed() async {
      await service.deleteTemplate(widget.template!);
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
      var template = _viewModel.toTemplate();
      AvailabilityError? error;
      try {
        if (widget.template == null) {
          await service.createTemplate(template);
        } else {
          await service.updateTemplate(template);
        }
        widget.onExit();
      } on BreakEndBeforeStartException {
        error = AvailabilityError.breakEndBeforeStart;
      } on BreakSubmittedDurationTooLongException {
        error = AvailabilityError.breakSubmittedDurationTooLong;
      } on TemplateEndBeforeStartException {
        error = AvailabilityError.endBeforeStart;
      } on TemplateBreakBeforeStartException {
        error = AvailabilityError.templateBreakBeforeStart;
      } on TemplateBreakAfterEndException {
        error = AvailabilityError.templateBreakAfterEnd;
      }
      if (error != null && context.mounted) {
        await options.errorDisplayBuilder(
          context,
          error,
        );
      }
    }

    useEffect(() {
      availabilityScope.popHandler.add(onBackPressed);
      return () => availabilityScope.popHandler.remove(onBackPressed);
    });

    var canSave = _viewModel.canSave;
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

    var title = Center(
      child: Text(
        translations.weekTemplateTitle,
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
      onColorSelected: (color) {
        setState(() {
          _viewModel = _viewModel.copyWith(color: color);
        });
      },
    );

    var editPage = [
      _WeekTemplateSidePadding(child: templateTitleSection),
      const SizedBox(height: 24),
      Padding(
        padding: EdgeInsets.only(left: spacing.sidePadding),
        child: TemplateWeekDaySelection(
          initialSelectedDay: _selectedDay.index,
          onDaySelected: onDaySelected,
        ),
      ),
      const SizedBox(height: 24),
      _WeekTemplateSidePadding(
        child: TemplateTimeAndBreakSection(
          dayData: selectedDayData ?? const DayTemplateDataViewModel(),
          onDayDataChanged: onDayDataChanged,
        ),
      ),
      const SizedBox(height: 24),
      _WeekTemplateSidePadding(child: colorSection),
    ];

    var overviewPage = _WeekTemplateSidePadding(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              translations.templateTitleLabel,
              style: textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 1,
              ),
              borderRadius: options.borderRadius,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(_viewModel.color ?? 0),
                    borderRadius: options.borderRadius,
                  ),
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _viewModel.name ?? "",
                    style: textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          TemplateWeekOverview(
            template: _viewModel,
            onClickEdit: onBackPressed,
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
                children: [
                  if (_editing) ...[
                    nextButton,
                  ] else ...[
                    saveButton,
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
