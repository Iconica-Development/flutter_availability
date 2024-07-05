import "package:flutter/material.dart";
import "package:flutter_availability/flutter_availability.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class CalendarGrid extends StatelessWidget {
  ///
  const CalendarGrid({
    required this.month,
    required this.days,
    super.key,
  });

  /// The current month to display
  final DateTime month;

  /// A list of days that need to be displayed differently
  final List<CalendarDay> days;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var colorScheme = theme.colorScheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var colors = options.colors;
    var translations = options.translations;
    var calendarDays = _generateCalendarDays(month, days, colors, colorScheme);

    // get the names of the days of the week
    var dayNames = List.generate(7, (index) {
      var day = DateTime(2024, 7, 8 + index); // this is a monday
      return translations.weekDayAbbreviatedFormatter(context, day);
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayNames
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: textTheme.bodyLarge,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4.0),
        GridView.builder(
          shrinkWrap: true,
          itemCount: calendarDays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            var day = calendarDays[index];
            var textColor = day.outsideMonth
                ? colors.outsideMonthTextColor ?? colorScheme.onSurface
                : _getTextColor(
                    day.color,
                    colors.textLightColor ?? Colors.white,
                    colors.textDarkColor,
                  );
            var textStyle = textTheme.bodyLarge?.copyWith(color: textColor);

            return GestureDetector(
              onTap: () {
                // Handle day tap here
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: day.outsideMonth ? Colors.transparent : day.color,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: day.isSelected
                        ? colorScheme.primary
                        : Colors.transparent,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(day.date.day.toString(), style: textStyle),
                    ),
                    if (day.templateDeviation) ...[
                      Positioned(
                        right: 4,
                        child: Text("*", style: textStyle),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// A Special day in the calendar that needs to be displayed differently
class CalendarDay {
  ///
  const CalendarDay({
    required this.date,
    required this.isSelected,
    required this.color,
    required this.templateDeviation,
    this.outsideMonth = false,
  });

  /// The date of the day
  final DateTime date;

  /// Whether the day is selected or not
  final bool isSelected;

  /// The color of the day
  final Color color;

  /// Whether there is an availability on this day and it deviates from the
  /// used template
  final bool templateDeviation;

  /// Whether the day is outside of the current month
  final bool outsideMonth;

  /// Creates a copy of the current day with the provided values
  CalendarDay copyWith({
    DateTime? date,
    bool? isSelected,
    Color? color,
    bool? templateDeviation,
    bool? outsideMonth,
  }) =>
      CalendarDay(
        date: date ?? this.date,
        isSelected: isSelected ?? this.isSelected,
        color: color ?? this.color,
        templateDeviation: templateDeviation ?? this.templateDeviation,
        outsideMonth: outsideMonth ?? this.outsideMonth,
      );
}

List<CalendarDay> _generateCalendarDays(
  DateTime month,
  List<CalendarDay> days,
  AvailabilityColors colors,
  ColorScheme colorScheme,
) {
  var firstDayOfMonth = DateTime(month.year, month.month, 1);
  var lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
  var daysInMonth = lastDayOfMonth.day;
  var startWeekday = firstDayOfMonth.weekday;
  var endWeekday = lastDayOfMonth.weekday;

  var calendarDays = <CalendarDay>[];

  // Add days from the previous month
  for (var i = 0; i < startWeekday - 1; i++) {
    var prevDay =
        firstDayOfMonth.subtract(Duration(days: startWeekday - 1 - i));
    calendarDays.add(
      CalendarDay(
        date: prevDay,
        isSelected: false,
        color: Colors.transparent,
        templateDeviation: false,
        outsideMonth: true,
      ),
    );
  }

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
      ),
    );
    // if the day is selected we need to change the color
    specialDay = specialDay.copyWith(
      color: specialDay.isSelected
          ? colors.selectedDayColor ?? colorScheme.primaryFixedDim
          : null,
    );
    calendarDays.add(specialDay);
  }

  // Add days from the next month
  for (var i = endWeekday; i < 7; i++) {
    var nextDay = lastDayOfMonth.add(Duration(days: i - endWeekday + 1));
    calendarDays.add(
      CalendarDay(
        date: nextDay,
        isSelected: false,
        color: Colors.transparent,
        templateDeviation: false,
        outsideMonth: true,
      ),
    );
  }

  return calendarDays;
}

Color? _getTextColor(
  Color backgroundColor,
  Color lightColor,
  Color? darkColor,
) =>
    backgroundColor.computeLuminance() > 0.5 ? darkColor : lightColor;
