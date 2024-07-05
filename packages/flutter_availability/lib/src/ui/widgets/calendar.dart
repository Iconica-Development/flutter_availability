import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/widgets/calendar_grid.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class CalendarView extends StatelessWidget {
  ///
  const CalendarView({
    required this.month,
    required this.onMonthChanged,
    super.key,
  });

  ///
  final DateTime month;

  ///
  final void Function(DateTime month) onMonthChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    var monthDateSelector = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            onMonthChanged(DateTime(month.year, month.month - 1));
          },
        ),
        const SizedBox(width: 44),
        Text(
          translations.monthYearFormatter(context, month),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(width: 44),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            onMonthChanged(DateTime(month.year, month.month + 1));
          },
        ),
      ],
    );

    var calendarGrid = CalendarGrid(
      month: month,
      days: [
        CalendarDay(
          date: DateTime(month.year, month.month, 3),
          isSelected: false,
          color: Colors.red,
          templateDeviation: false,
        ),
        CalendarDay(
          date: DateTime(month.year, month.month, 4),
          isSelected: false,
          color: Colors.red,
          templateDeviation: true,
        ),
        CalendarDay(
          date: DateTime(month.year, month.month, 10),
          isSelected: false,
          color: Colors.blue,
          templateDeviation: false,
        ),
        CalendarDay(
          date: DateTime(month.year, month.month, 11),
          isSelected: false,
          color: Colors.black,
          templateDeviation: true,
        ),
        CalendarDay(
          date: DateTime(month.year, month.month, 12),
          isSelected: false,
          color: Colors.white,
          templateDeviation: true,
        ),
        CalendarDay(
          date: DateTime(month.year, month.month, 13),
          isSelected: true,
          color: Colors.green,
          templateDeviation: false,
        ),
        CalendarDay(
          date: DateTime(month.year, month.month, 14),
          isSelected: true,
          color: Colors.green,
          templateDeviation: true,
        ),
      ],
    );

    return Column(
      children: [
        monthDateSelector,
        const Divider(),
        calendarGrid,
      ],
    );
  }
}
