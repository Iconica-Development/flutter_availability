import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_translations.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/widgets/calendar_grid.dart";
import "package:flutter_availability/src/util/availability_deviation.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class CalendarView extends StatelessWidget {
  ///
  const CalendarView({
    required this.month,
    required this.availabilities,
    required this.onMonthChanged,
    required this.onEditDateRange,
    required this.selectedRange,
    super.key,
  });

  ///
  final DateTime month;

  /// The stream of availabilities with templates for the current month
  final AsyncSnapshot<List<AvailabilityWithTemplate>> availabilities;

  ///
  final void Function(DateTime month) onMonthChanged;

  /// Callback for when the date range is edited by the user
  final void Function(DateTimeRange? range) onEditDateRange;

  ///
  final DateTimeRange? selectedRange;

  void _onTapDate(DateTime day) {
    // if there is already a range selected, with a single date and the date
    //that is selected is after it we extend the range
    if (selectedRange != null &&
        day.isAfter(selectedRange!.start) &&
        selectedRange!.start == selectedRange!.end) {
      onEditDateRange(
        DateTimeRange(
          start: selectedRange!.start,
          end: day,
        ),
      );
      return;
    }

    // if select the already selected date we want to clear the range
    if (selectedRange != null &&
        day.isAtSameMomentAs(selectedRange!.start) &&
        day.isAtSameMomentAs(selectedRange!.end)) {
      onEditDateRange(null);
      return;
    }

    // if there is already a range selected we want to clear
    //it and start a new one
    onEditDateRange(DateTimeRange(start: day, end: day));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    var mappedCalendarDays = _mapAvailabilitiesToCalendarDays(availabilities);

    var monthDateSelector = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            onMonthChanged(
              DateTime(month.year, month.month - 1),
            );
          },
        ),
        const SizedBox(width: 44),
        SizedBox(
          width: _calculateTextWidthOfLongestMonth(context, translations),
          child: Text(
            translations.monthYearFormatter(context, month),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 44),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            onMonthChanged(
              DateTime(month.year, month.month + 1),
            );
          },
        ),
      ],
    );

    var calendarGrid = CalendarGrid(
      month: month,
      days: mappedCalendarDays,
      onDayTap: _onTapDate,
      selectedRange: selectedRange,
    );

    return Column(
      children: [
        monthDateSelector,
        const Divider(height: 1),
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

/// Maps the availabilities to CalendarDays
/// This is a helper function to make the code more readable
/// It also determines if the template is a deviation from the original
List<CalendarDay> _mapAvailabilitiesToCalendarDays(
  AsyncSnapshot<List<AvailabilityWithTemplate>> availabilitySnapshot,
) =>
    availabilitySnapshot.data?.map(
      (availability) {
        var templateIsDeviated = availability.template != null &&
            isTemplateDeviated(
              availability.availabilityModel,
              availability.template!,
            );
        return CalendarDay(
          date: availability.availabilityModel.startDate,
          color: availability.template != null
              ? Color(availability.template!.color)
              : null,
          templateDeviation: templateIsDeviated,
          isSelected: false,
        );
      },
    ).toList() ??
    [];
