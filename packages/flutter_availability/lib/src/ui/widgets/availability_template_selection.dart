import "package:flutter/material.dart";

/// Selection of the template to use for the availability
/// 
/// This can show multiple templates when the user selects a date range.
/// When updating the templates for a date range where there are multiple 
/// different templates used, the user first needs to remove the existing 
/// templates.
class AvailabilityTemplateSelection extends StatelessWidget {
  /// Constructor
  const AvailabilityTemplateSelection({super.key});

  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 50, child: Placeholder());
}
