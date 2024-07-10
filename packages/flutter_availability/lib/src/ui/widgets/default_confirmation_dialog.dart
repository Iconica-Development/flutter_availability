import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";

/// Default confirmation dialog that uses a modal bottom sheet, it has a title,
/// a description and it gets a secondary and primary button to confirm or
/// cancel the action
class DefaultConfirmationDialog extends StatelessWidget {
  ///
  const DefaultConfirmationDialog({
    required this.title,
    required this.description,
    super.key,
  });

  /// Shows a confirmation dialog with a title and a description
  static Future<bool?> builder(
    BuildContext context, {
    required String title,
    required String description,
  }) =>
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(),
        builder: (context) => DefaultConfirmationDialog(
          title: title,
          description: description,
        ),
      );

  /// The title shown in the dialog
  final String title;

  /// The description shown in the dialog
  final String description;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var spacing = options.spacing;
    var translations = options.translations;

    void onCancel() => Navigator.of(context).pop(false);
    void onConfirm() => Navigator.of(context).pop(true);

    return Padding(
      padding: EdgeInsets.only(
        top: 40,
        left: spacing.sidePadding,
        right: spacing.sidePadding,
        bottom: spacing.bottomButtonPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: options.secondaryButtonBuilder(
                  context,
                  onCancel,
                  Text(translations.cancelText),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: options.primaryButtonBuilder(
                  context,
                  onConfirm,
                  Text(translations.confirmText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
