// ignore_for_file: avoid_positional_boolean_parameters

import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/widgets/calendar_grid.dart";
import "package:flutter_availability/src/util/scope.dart";

/// A widget for selecting a day of the week
class TemplateWeekDaySelection extends StatefulWidget {
  /// Creates a [TemplateWeekDaySelection]
  const TemplateWeekDaySelection({
    required this.onDaySelected,
    required this.initialSelectedDay,
    super.key,
  });

  /// The initial day that should be selected when the widget is first created
  /// This should be an index of the days of the week starting with 0 for Monday
  final int initialSelectedDay;

  /// Callback for when a day is selected
  final void Function(int) onDaySelected;

  @override
  State<TemplateWeekDaySelection> createState() =>
      _TemplateWeekDaySelectionState();
}

class _TemplateWeekDaySelectionState extends State<TemplateWeekDaySelection> {
  late int _selectedDayIndex = widget.initialSelectedDay;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    var days = getDaysOfTheWeekAsAbbreviatedStrings(translations, context);

    void onDaySelected(bool selected, int index) {
      if (!selected) return;
      widget.onDaySelected(index);
      setState(() {
        _selectedDayIndex = index;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translations.weekTemplateDayTitle, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 72,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var day in days) ...[
                  _DaySelectionCard(
                    day: day,
                    days: days,
                    selectedDayIndex: _selectedDayIndex,
                    onDaySelected: (selected) =>
                        onDaySelected(selected, days.indexOf(day)),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DaySelectionCard extends StatelessWidget {
  const _DaySelectionCard({
    required this.selectedDayIndex,
    required this.day,
    required this.days,
    required this.onDaySelected,
  });

  final String day;
  final List<String> days;

  final int selectedDayIndex;

  final void Function(bool) onDaySelected;

  @override
  Widget build(BuildContext context) {
    var index = days.indexOf(day);
    var isSelected = index == selectedDayIndex;

    return _DaySelectionCardLayout(
      day: day,
      isSelected: isSelected,
      onDaySelected: onDaySelected,
    );
  }
}

class _DaySelectionCardLayout extends StatelessWidget {
  const _DaySelectionCardLayout({
    required this.day,
    required this.isSelected,
    required this.onDaySelected,
  });

  final String day;
  final bool isSelected;

  final void Function(bool) onDaySelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var abbreviationTextStyle = textTheme.headlineMedium;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;

    abbreviationTextStyle = isSelected
        ? abbreviationTextStyle?.copyWith(
            color: theme.colorScheme.onPrimary,
          )
        : abbreviationTextStyle;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isSelected ? 72 : 64,
      width: isSelected ? 72 : 64,
      child: ChoiceChip(
        shape: RoundedRectangleBorder(borderRadius: options.borderRadius),
        padding: EdgeInsets.zero,
        label: Center(
          child: Text(
            day.toUpperCase(),
            style: abbreviationTextStyle,
          ),
        ),
        selected: isSelected,
        showCheckmark: theme.chipTheme.showCheckmark ?? false,
        onSelected: onDaySelected,
      ),
    );
  }
}
