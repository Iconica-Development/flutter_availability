import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/view_models/break_view_model.dart";
import "package:flutter_availability/src/ui/view_models/template_daydata_view_model.dart";
import "package:flutter_availability/src/ui/view_models/week_template_view_models.dart";
import "package:flutter_availability/src/ui/widgets/calendar_grid.dart";
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
    var colors = options.colors;

    var dayNames = getDaysOfTheWeekAsStrings(translations, context);

    var templateData = template.data;

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
            options.smallTextButtonBuilder(
              context,
              onClickEdit,
              Text(
                translations.editTemplateButton,
              ),
            ),
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
              for (var day in WeekDay.values) ...[
                _TemplateDayDetailRow(
                  dayName: dayNames[day.index],
                  dayData:
                      templateData.containsKey(day) ? templateData[day] : null,
                  isOdd: day.index.isOdd,
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
  });

  /// The name of the day
  final String dayName;

  /// There odd rows do not have a background color
  /// This causes a layered effect
  final bool isOdd;

  /// The data of the day
  final DayTemplateDataViewModel? dayData;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

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
              Text(dayPeriod, style: textTheme.bodyLarge),
            ],
          ),
          // for each break add a line
          for (var dayBreak in breaks) ...[
            const SizedBox(height: 4),
            _TemplateDayDetailPauseRow(dayBreakViewModel: dayBreak),
          ],
        ],
      ),
    );
  }
}

class _TemplateDayDetailPauseRow extends StatelessWidget {
  const _TemplateDayDetailPauseRow({
    required this.dayBreakViewModel,
  });

  final BreakViewModel dayBreakViewModel;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

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
        Text(
          pausePeriod,
          style: pauseTextStyle,
        ),
      ],
    );
  }
}
