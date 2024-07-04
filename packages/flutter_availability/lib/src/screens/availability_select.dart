import "package:flutter/material.dart";
import "package:intl/intl.dart";

///
class AvailabilitySelectionScreen extends StatelessWidget {
  ///
  const AvailabilitySelectionScreen({
    required this.selectedDates,
    required this.onTemplateSelectClicked,
    super.key,
  });

  /// The selected [DateTimeRange] for which the user is selecting availability
  final DateTimeRange selectedDates;

  /// Callback for when the user selects a template and should return a
  /// templateid or null
  final Future<String?> Function() onTemplateSelectClicked;

  @override
  Widget build(BuildContext context) {
    void onClickNext() {}

    Future<void> onClickSelectTemplate() async {
      var selectedTemplate = await onTemplateSelectClicked();
      debugPrint(selectedTemplate);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("When"),
              Text(
                "From ${DateFormat.yMd().format(selectedDates.start)} till"
                " ${DateFormat.yMd().format(selectedDates.end)}",
              ),
              FilledButton(
                onPressed: onClickSelectTemplate,
                child: const Text("Select a template"),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: onClickNext,
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }
}
