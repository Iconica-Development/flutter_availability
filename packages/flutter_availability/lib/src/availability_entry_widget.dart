import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_options.dart";
import "package:flutter_availability/src/userstories.dart";

/// A widget representing an entry point for the Availability user story.
class AvailabilityEntryWidget extends StatelessWidget {
  /// Constructs a [AvailabilityEntryWidget].
  const AvailabilityEntryWidget({
    this.options,
    this.onTap,
    this.userId = "",
    this.widgetSize = 75,
    this.backgroundColor = Colors.grey,
    this.icon = Icons.event_available_outlined,
    this.iconColor = Colors.black,
    super.key,
  });

  /// The user id for which the availability should be displayed.
  final String userId;

  /// Options to configure the availability user story.
  final AvailabilityOptions? options;

  /// Background color of the widget.
  final Color backgroundColor;

  /// Size of the widget.
  final double widgetSize;

  /// Callback function triggered when the widget is tapped. If this is not null
  /// the callback will be triggered otherwise the availability user story will
  /// be opened
  final VoidCallback? onTap;

  /// Icon to be displayed.
  final IconData icon;

  /// Color of the icon.
  final Color iconColor;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () async {
          if (onTap != null) {
            onTap?.call();
          } else {
            await openAvailabilitiesForUser(context, "", options);
          }
        },
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Container(
          width: widgetSize,
          height: widgetSize,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
          child: Icon(icon, color: iconColor, size: widgetSize / 1.5),
        ),
      );
}
