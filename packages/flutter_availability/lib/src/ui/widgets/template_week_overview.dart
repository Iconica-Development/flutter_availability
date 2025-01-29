import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/view_models/break_view_model.dart";
import "package:flutter_availability/src/ui/view_models/template_daydata_view_model.dart";
import "package:flutter_availability/src/ui/view_models/week_template_view_models.dart";
import "package:flutter_availability/src/ui/widgets/calendar_grid.dart";
import "package:flutter_availability/src/ui/widgets/semantic_widget.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Shows an overview of the template of a week before saving it
class TemplateWeekOverview extends StatelessWidget {
  ///
  const TemplateWeekOverview({
    required this.template,
    required this.onClickEdit,
    super.key,
  });

  /// The template to show
  final WeekTemplateViewModel template;

  /// The callback for the textbutton to edit the week template
  final VoidCallback onClickEdit;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;
    var identifiers = options.accessibilityIds;
    var colors = options.colors;

    var dayNames = getDaysOfTheWeekAsStrings(translations, context);

    var templateData = template.data;

    var editButton = CustomSemantics(
      identifier: identifiers.weekTemplateEditButtonIdentifier,
      child: options.smallTextButtonBuilder(
        context,
        onClickEdit,
        Text(
          translations.editTemplateButton,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                translations.weekTemplateOverviewTitle,
                style: textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            editButton,
          ],
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.templateWeekOverviewBackgroundColor ??
                theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
          child: Column(
            children: [
              for (var (index, day) in WeekDay.values.indexed) ...[
                _TemplateDayDetailRow(
                  dayName: dayNames[index],
                  dayData:
                      templateData.containsKey(day) ? templateData[day] : null,
                  index: index,
                  isOdd: index.isOdd,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplateDayDetailRow extends StatelessWidget {
  const _TemplateDayDetailRow({
    required this.dayName,
    required this.dayData,
    required this.isOdd,
    required this.index,
  });

  /// The name of the day
  final String dayName;

  /// There odd rows do not have a background color
  /// This causes a layered effect
  final bool isOdd;

  /// The index of the day
  final int index;

  /// The data of the day
  final DayTemplateDataViewModel? dayData;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;
    var identifiers = options.accessibilityIds;

    var startTime = dayData?.startTime;
    var endTime = dayData?.endTime;
    var dayHasAvailability = startTime != null && endTime != null;
    String? dayPeriod;
    if (dayHasAvailability) {
      dayPeriod = "${translations.timeFormatter(context, startTime)} - "
          "${translations.timeFormatter(context, endTime)}";
    } else {
      dayPeriod = translations.unavailable;
    }

    var dayPeriodIdentifier = "${identifiers.weekDayTimeIdentifier}_$index";

    var breaks = dayData?.breaks ?? <BreakViewModel>[];

    BoxDecoration? boxDecoration;
    if (isOdd) {
      boxDecoration = BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: theme.dividerColor,
          ),
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      );
    }

    return Container(
      decoration: boxDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dayName, style: textTheme.bodyLarge),
              CustomSemantics(
                identifier: dayPeriodIdentifier,
                child: Text(
                  dayPeriod,
                  style: textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          // for each break add a line
          for (var (breakIndex, dayBreak) in breaks.indexed) ...[
            const SizedBox(height: 4),
            _TemplateDayDetailPauseRow(
              dayBreakViewModel: dayBreak,
              dayIndex: index,
              breakIndex: breakIndex,
            ),
          ],
        ],
      ),
    );
  }
}

class _TemplateDayDetailPauseRow extends StatelessWidget {
  const _TemplateDayDetailPauseRow({
    required this.dayBreakViewModel,
    required this.dayIndex,
    required this.breakIndex,
  });

  final BreakViewModel dayBreakViewModel;

  /// The index of the day in the list of days
  /// This is used to create unique identifiers when there are multiple days
  /// with breaks
  final int dayIndex;

  /// The index of the break in the list of breaks
  final int breakIndex;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;
    var identifiers = options.accessibilityIds;

    var dayBreak = dayBreakViewModel.toBreak();
    var startTime = TimeOfDay.fromDateTime(dayBreak.startTime);
    var endTime = TimeOfDay.fromDateTime(dayBreak.endTime);
    var startTimeString = translations.timeFormatter(context, startTime);
    var endTimeString = translations.timeFormatter(context, endTime);
    var pausePeriod =
        "$startTimeString - $endTimeString (${dayBreak.duration.inMinutes} "
        "${translations.timeMinutesShort})";
    var pauseTextStyle = textTheme.bodyMedium?.copyWith(
      fontStyle: FontStyle.italic,
    );

    var breakIdentifier =
        "${identifiers.weekDayBreakIdentifier}_${dayIndex}_$breakIndex";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            translations.pause,
            style: pauseTextStyle,
          ),
        ),
        CustomSemantics(
          identifier: breakIdentifier,
          child: Text(
            pausePeriod,
            style: pauseTextStyle,
          ),
        ),
      ],
    );
  }
}
