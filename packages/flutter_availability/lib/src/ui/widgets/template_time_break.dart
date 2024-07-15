import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/models/view_template_daydata.dart";
import "package:flutter_availability/src/ui/widgets/pause_selection.dart";
import "package:flutter_availability/src/ui/widgets/template_time_selection.dart";

/// Section for selecting the time and breaks for a single day 
class TemplateTimeAndBreakSection extends StatelessWidget {
  ///
  const TemplateTimeAndBreakSection({
    required this.onDayDataChanged,
    this.dayData = const ViewDayTemplateData(),
    super.key,
  });

  /// The day data to display and edit
  final ViewDayTemplateData dayData;

  /// Callback for when the day data changes
  final void Function(ViewDayTemplateData data) onDayDataChanged;

  @override
  Widget build(BuildContext context) => Column(
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
          const SizedBox(height: 24),
          PauseSelection(
            editingTemplate: true,
            breaks: dayData.breaks,
            onBreaksChanged: (pauses) =>
                onDayDataChanged(dayData.copyWith(breaks: pauses)),
          ),
        ],
      );
}
