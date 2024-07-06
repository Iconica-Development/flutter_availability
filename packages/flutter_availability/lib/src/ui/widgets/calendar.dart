import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_translations.dart";
import "package:flutter_availability/src/ui/widgets/calendar_grid.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class CalendarView extends StatefulWidget {
  ///
  const CalendarView({
    required this.month,
    required this.onMonthChanged,
    required this.onEditDateRange,
    super.key,
  });

  ///
  final DateTime month;

  ///
  final void Function(DateTime month) onMonthChanged;

  /// Callback for when the date range is edited by the user
  final void Function(DateTimeRange? range) onEditDateRange;

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTimeRange? _selectedRange;

  void onTapDate(DateTime day) {
    // if there is already a range selected, with a single date and the date
    //that is selected is after it we extend the range
    if (_selectedRange != null &&
        day.isAfter(_selectedRange!.start) &&
        _selectedRange!.start == _selectedRange!.end) {
      setState(() {
        _selectedRange = DateTimeRange(
          start: _selectedRange!.start,
          end: day,
        );
      });
      widget.onEditDateRange(_selectedRange);
      return;
    }

    // if select the already selected date we want to clear the range
    if (_selectedRange != null &&
        day.isAtSameMomentAs(_selectedRange!.start) &&
        day.isAtSameMomentAs(_selectedRange!.end)) {
      setState(() {
        _selectedRange = null;
      });
      widget.onEditDateRange(_selectedRange);
      return;
    }

    // if there is already a range selected we want to clear
    //it and start a new one
    setState(() {
      _selectedRange = DateTimeRange(start: day, end: day);
    });
    widget.onEditDateRange(_selectedRange);
  }

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
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            widget.onMonthChanged(
              DateTime(widget.month.year, widget.month.month - 1),
            );
          },
        ),
        const SizedBox(width: 44),
        SizedBox(
          width: _calculateTextWidthOfLongestMonth(context, translations),
          child: Text(
            translations.monthYearFormatter(context, widget.month),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 44),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            widget.onMonthChanged(
              DateTime(widget.month.year, widget.month.month + 1),
            );
          },
        ),
      ],
    );

    var calendarGrid = CalendarGrid(
      month: widget.month,
      days: const [],
      onDayTap: onTapDate,
      selectedRange: _selectedRange,
    );

    return Column(
      children: [
        monthDateSelector,
        const Divider(),
        const SizedBox(height: 20),
        calendarGrid,
      ],
    );
  }
}

/// loops through all the months of a year and get the width of the
/// longest month,
/// this is used to make sure the month selector is always the same width
double _calculateTextWidthOfLongestMonth(
  BuildContext context,
  AvailabilityTranslations translations,
) {
  var longestMonth = List.generate(12, (index) {
    var month = DateTime(2024, index + 1);
    return translations.monthYearFormatter(context, month);
  }).reduce(
    (value, element) => value.length > element.length ? value : element,
  );
  // now we calculate the width of the longest month
  var textPainter = TextPainter(
    text: TextSpan(
      text: longestMonth,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  return textPainter.width;
}
