import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// A wrapper that wraps a widget with a [Semantics] widget.
/// This is used for testing purposes to add a unique identifier to a widget.
/// Use this element for all widgets that have something that should be
/// selectable in tests (buttons, textfields, dynamic texts)
/// The [identifier] should be unique for the specific screen.
/// To make sure the accessibility ID is set for all platforms this widget
/// uses a label for android when it is not a textfield.
/// [container] is set to true to make sure the widget is always its own
/// accessibility element.
/// [excludeSemantics] is set to false to make sure that children of this widget
/// can still be interacted with.
/// [isTextField] can be set to true because for textField the
/// [excludeSemantics] modifies the behavior of the textfield in e2e tests.
class CustomSemantics extends StatelessWidget {
  /// Creates a [CustomSemantics] widget.
  /// The [identifier] should be unique for the specific screen.
  /// [isTextField] if this widget is a TextField or TextFormField
  /// [excludeSemantics] if the [Semantics] widget should exclude the semantics
  /// of its children. This is done by default if it not a textfield.
  const CustomSemantics({
    required this.identifier,
    required this.child,
    this.excludeSemantics = false,
    this.isTextField = false,
    super.key,
  });

  /// The widget that should be wrapped with a [Semantics] widget.
  final Widget child;

  /// Identifier for the widget that should be unique for the specific screen.
  final String? identifier;

  /// If the [Semantics] widget should exclude the semantics of its children.
  final bool excludeSemantics;

  /// If the widget is a textfield, the [child] can't be excluded. This is
  /// because otherwise the textfield doesn't work in e2e tests with Appium.
  final bool isTextField;

  @override
  Widget build(BuildContext context) {
    var isAndroid = !kIsWeb && Platform.isAndroid;

    var excludeSemantics = (!isTextField && isAndroid) || this.excludeSemantics;

    var label = !isTextField && isAndroid ? identifier : null;

    return Semantics(
      excludeSemantics: excludeSemantics,
      container: true,
      label: label,
      identifier: identifier,
      child: child,
    );
  }
}
