import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_options.dart";
import "package:flutter_availability/src/ui/view_models/template_daydata_view_model.dart";
import "package:flutter_availability/src/ui/widgets/pause_selection.dart";
import "package:flutter_availability/src/ui/widgets/template_time_selection.dart";
import "package:flutter_availability/src/util/scope.dart";

/// Section for selecting the time and breaks for a single day
class TemplateTimeAndBreakSection extends StatelessWidget {
  ///
  const TemplateTimeAndBreakSection({
    required this.onDayDataChanged,
    this.dayData = const DayTemplateDataViewModel(),
    super.key,
  });

  /// The day data to display and edit
  final DayTemplateDataViewModel dayData;

  /// Callback for when the day data changes
  final void Function(DayTemplateDataViewModel data) onDayDataChanged;

  @override
  Widget build(BuildContext context) {
    var featureSet = AvailabilityScope.of(context).options.featureSet;
    return Column(
      children: [
        TemplateTimeSelection(
          key: ValueKey([dayData.startTime, dayData.endTime]),
          startTime: dayData.startTime,
          endTime: dayData.endTime,
          onStartChanged: (start) =>
              onDayDataChanged(dayData.copyWith(startTime: start)),
          onEndChanged: (end) =>
              onDayDataChanged(dayData.copyWith(endTime: end)),
        ),
        if (featureSet.require(AvailabilityFeature.breaks)) ...[
          const SizedBox(height: 24),
          PauseSelection(
            editingTemplate: true,
            breaks: dayData.breaks,
            onBreaksChanged: (pauses) =>
                onDayDataChanged(dayData.copyWith(breaks: pauses)),
          ),
        ],
      ],
    );
  }
}
