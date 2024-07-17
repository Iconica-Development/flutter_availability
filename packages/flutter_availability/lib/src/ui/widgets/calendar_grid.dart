import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class CalendarGrid extends StatelessWidget {
  ///
  const CalendarGrid({
    required this.month,
    required this.days,
    required this.onDayTap,
    required this.selectedRange,
    super.key,
  });

  /// The current month to display
  final DateTime month;

  /// A list of days that need to be displayed differently
  final List<CalendarDay> days;

  /// A callback that is called when a day is tapped
  final void Function(DateTime) onDayTap;

  /// The selected range of dates
  final DateTimeRange? selectedRange;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var colorScheme = theme.colorScheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var colors = options.colors;
    var translations = options.translations;
    var calendarDays =
        _generateCalendarDays(month, days, selectedRange, colors, colorScheme);

    var dayNames = getDaysOfTheWeekAsAbbreviatedStrings(translations, context);

    var calendarDaysRow = Row(
      children: List.generate(13, (index) {
        // This adds a space between the days of the week
        if ((index % 2).isOdd) return const SizedBox(width: 12);

        var day = dayNames[index ~/ 2];
        return Expanded(
          child: Text(
            day,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        );
      }),
    );

    return Column(
      children: [
        calendarDaysRow,
        const SizedBox(height: 10),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: calendarDays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            var day = calendarDays[index];
            return _CalendarDayTile(
              day: day,
              onDayTap: onDayTap,
            );
          },
        ),
      ],
    );
  }
}

class _CalendarDayTile extends StatelessWidget {
  const _CalendarDayTile({
    required this.day,
    required this.onDayTap,
  });

  final CalendarDay day;
  final void Function(DateTime) onDayTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var colorScheme = theme.colorScheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var colors = options.colors;

    var dayColor =
        day.color ?? colors.customAvailabilityColor ?? colorScheme.secondary;
    Color? textColor;
    TextStyle? textStyle;
    if (day.outsideMonth) {
      textColor = colors.outsideMonthTextColor ?? colorScheme.onSurface;
      textStyle = textTheme.bodyMedium?.copyWith(color: textColor);
    } else if (day.hasAvailability) {
      textColor = dayColor;
      textStyle = textTheme.titleMedium?.copyWith(color: textColor);
    }

    var decoration = day.outsideMonth
        ? null
        : BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: textColor ?? Colors.transparent,
                width: 1,
              ),
            ),
          );

    return InkWell(
      onTap: () => onDayTap(day.date),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: day.isSelected ? theme.dividerColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: decoration,
                child: Text(day.date.day.toString(), style: textStyle),
              ),
            ),
            if (day.templateDeviation)
              Positioned(
                right: 4,
                child: Text("*", style: textStyle),
              ),
          ],
        ),
      ),
    );
  }
}

/// Returns the days of the week as abbreviated strings
/// The first day of the week is monday
List<String> getDaysOfTheWeekAsAbbreviatedStrings(
  AvailabilityTranslations translations,
  BuildContext context,
) {
  var dayNames = List.generate(7, (index) {
    var day = DateTime(2024, 7, 8 + index); // this is a monday
    return translations.weekDayAbbreviatedFormatter(context, day);
  });
  return dayNames;
}

/// Returns the days of the week as strings
List<String> getDaysOfTheWeekAsStrings(
  AvailabilityTranslations translations,
  BuildContext context,
) {
  var dayNames = List.generate(7, (index) {
    var day = DateTime(2024, 7, 8 + index); // this is a monday
    return translations.weekDayFormatter(context, day);
  });
  return dayNames;
}

/// A Special day in the calendar that needs to be displayed differently
class CalendarDay {
  ///
  const CalendarDay({
    required this.date,
    required this.isSelected,
    required this.color,
    required this.templateDeviation,
    required this.hasAvailability,
    this.outsideMonth = false,
  });

  /// The date of the day
  final DateTime date;

  /// Whether the day is selected or not
  final bool isSelected;

  /// The color of the day
  /// If there is no template for an availability the color will be null
  final Color? color;

  /// Whether there is an availability on this day and it deviates from the
  /// used template
  final bool templateDeviation;

  /// Whether the day is outside of the current month
  final bool outsideMonth;

  /// Whether the day has availability
  final bool hasAvailability;

  /// Creates a copy of the current day with the provided values
  CalendarDay copyWith({
    DateTime? date,
    bool? isSelected,
    Color? color,
    bool? templateDeviation,
    bool? outsideMonth,
    bool? hasAvailability,
  }) =>
      CalendarDay(
        date: date ?? this.date,
        isSelected: isSelected ?? this.isSelected,
        color: color ?? this.color,
        templateDeviation: templateDeviation ?? this.templateDeviation,
        outsideMonth: outsideMonth ?? this.outsideMonth,
        hasAvailability: hasAvailability ?? this.hasAvailability,
      );
}

List<CalendarDay> _generateCalendarDays(
  DateTime month,
  List<CalendarDay> days,
  DateTimeRange? selectedRange,
  AvailabilityColors colors,
  ColorScheme colorScheme,
) {
  var firstDayOfMonth = DateTime(month.year, month.month, 1);
  var lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
  var daysInMonth = lastDayOfMonth.day;
  var startWeekday = firstDayOfMonth.weekday;
  var endWeekday = lastDayOfMonth.weekday;

  var calendarDays = <CalendarDay>[];

  void addOutsideMonthDays(
    DateTime startDay,
    int count, {
    required bool isNextMonth,
  }) {
    for (var i = 0; i < count; i++) {
      // TODO(Joey): Never increase days with duration, always use internal
      // datetime math.
      var day = isNextMonth
          ? startDay.add(Duration(days: i + 1))
          : startDay.subtract(Duration(days: count - i));
      var isSelected = selectedRange != null &&
          !day.isBefore(selectedRange.start) &&
          !day.isAfter(selectedRange.end);
      calendarDays.add(
        CalendarDay(
          date: day,
          isSelected: isSelected,
          color: isSelected
              ? colors.selectedDayColor ?? colorScheme.primaryFixedDim
              : Colors.transparent,
          templateDeviation: false,
          outsideMonth: true,
          hasAvailability: false,
        ),
      );
    }
  }

  // Add days from the previous month
  addOutsideMonthDays(firstDayOfMonth, startWeekday - 1, isNextMonth: false);

  // Add days of the current month
  for (var i = 1; i <= daysInMonth; i++) {
    var day = DateTime(month.year, month.month, i);
    var specialDay = days.firstWhere(
      (d) =>
          d.date.day == i &&
          d.date.month == month.month &&
          d.date.year == month.year,
      orElse: () => CalendarDay(
        date: day,
        isSelected: false,
        color: colors.blankDayColor ?? colorScheme.surfaceDim,
        templateDeviation: false,
        hasAvailability: false,
      ),
    );
    var dayIsSelected = selectedRange != null &&
        !day.isBefore(selectedRange.start) &&
        !day.isAfter(selectedRange.end);
    specialDay = specialDay.copyWith(
      isSelected: dayIsSelected,
    );
    calendarDays.add(specialDay);
  }

  // Add days from the next month
  addOutsideMonthDays(lastDayOfMonth, 7 - endWeekday, isNextMonth: true);

  return calendarDays;
}
