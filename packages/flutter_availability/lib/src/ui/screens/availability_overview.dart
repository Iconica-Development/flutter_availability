import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/widgets/calendar.dart";
import "package:flutter_availability/src/util/scope.dart";

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
    );

    const templateLegend = SizedBox(
      height: 40,
      child: Placeholder(),
    );

    var startEditButton = options.primaryButtonBuilder(
      context,
      () {
        widget.onEditDateRange(
          DateTimeRange(start: DateTime(1), end: DateTime(2)),
        );
      },
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
