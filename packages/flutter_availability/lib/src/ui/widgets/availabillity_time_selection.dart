import "package:flutter/material.dart";
import "package:flutter_availability/src/ui/view_models/availability_view_model.dart";
import "package:flutter_availability/src/ui/widgets/generic_time_selection.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class AvailabilityTimeSelection extends StatelessWidget {
  ///
  const AvailabilityTimeSelection({
    required this.viewModel,
    required this.onStartChanged,
    required this.onEndChanged,
    super.key,
  });

  ///
  final AvailabilityViewModel viewModel;

  ///
  final void Function(TimeOfDay) onStartChanged;

  ///
  final void Function(TimeOfDay) onEndChanged;

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var translations = options.translations;

    var dateRange = viewModel.selectedRange;

    var isSingleDay = dateRange.start.isAtSameMomentAs(dateRange.end);
    var titleText = isSingleDay
        ? translations.availabilityTimeTitle
        : translations.availabilitiesTimeTitle;

    String? explanationText;
    if (viewModel.isDeviatingFromTemplate) {
      explanationText = isSingleDay
          ? translations.availabilityTemplateDeviationExplanation
          : translations.availabilitiesTemplateDeviationExplanation;
    }

    return Column(
      children: [
        TimeSelection(
          title: titleText,
          description: null,
          startTime: viewModel.startTime,
          endTime: viewModel.endTime,
          onStartChanged: onStartChanged,
          onEndChanged: onEndChanged,
        ),
        if (explanationText != null) ...[
          const SizedBox(height: 8),
          _AvailabilityExplanation(
            explanation: explanationText,
          ),
        ],
      ],
    );
  }
}

class _AvailabilityExplanation extends StatelessWidget {
  const _AvailabilityExplanation({
    required this.explanation,
  });

  final String explanation;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline),
        const SizedBox(width: 8),
        Expanded(child: Text(explanation, style: textTheme.bodyMedium)),
      ],
    );
  }
}
