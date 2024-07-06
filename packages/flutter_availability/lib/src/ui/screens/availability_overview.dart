import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/widgets/calendar.dart";
import "package:flutter_availability/src/ui/widgets/template_legend.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
class AvailabilityOverview extends StatefulWidget {
  ///
  const AvailabilityOverview({
    required this.onEditDateRange,
    required this.onViewTemplates,
    required this.onExit,
    super.key,
  });

  /// Callback for when the user clicks on a day
  final void Function(DateTimeRange range) onEditDateRange;

  /// Callback for when the user wants to navigate to the overview of templates
  final VoidCallback onViewTemplates;

  /// Callback for when the user wants to navigate back
  final VoidCallback onExit;

  @override
  State<AvailabilityOverview> createState() => _AvailabilityOverviewState();
}

class _AvailabilityOverviewState extends State<AvailabilityOverview> {
  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;
    var spacing = options.spacing;

    var title = Center(
      child: Text(
        translations.overviewScreenTitle,
        style: theme.textTheme.displaySmall,
      ),
    );

    var calendar = CalendarView(
      month: _selectedDate,
      onMonthChanged: (month) {
        setState(() {
          _selectedDate = month;
        });
      },
      onEditDateRange: (range) {
        setState(() {
          _selectedRange = range;
        });
      },
    );

    var templateLegend = TemplateLegend(
      onViewTemplates: widget.onViewTemplates,
      templates: [
        for (var template in <(Color, String)>[
          (Colors.red, "Template 1"),
          (Colors.blue, "Template 2"),
          // do 10 more
          (Colors.green, "Template 3"),
          (Colors.yellow, "Template 4"),
          (Colors.purple, "Template 5"),
          (Colors.orange, "Template 6"),
          (Colors.teal, "Template 7"),
          (Colors.pink, "Template 8"),
          (Colors.indigo, "Template 9"),
        ]) ...[
          AvailabilityTemplateModel(
            userId: "1",
            id: "1",
            name: template.$2,
            templateType: AvailabilityTemplateType.day,
            templateData: DayTemplateData(
              startTime: DateTime.now(),
              endTime: DateTime.now(),
              breaks: [],
            ),
            color: template.$1.value,
          ),
        ],
      ],
    );

    // if there is no range selected we want to disable the button
    var onButtonPress = _selectedRange == null
        ? null
        : () {
            widget.onEditDateRange(
              DateTimeRange(start: DateTime(1), end: DateTime(2)),
            );
          };

    var startEditButton = options.primaryButtonBuilder(
      context,
      onButtonPress,
      Text(translations.editAvailabilityButton),
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
              calendar,
              const SizedBox(height: 32),
              templateLegend,
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
              child: startEditButton,
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
