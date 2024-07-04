import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_translations.dart";
import "package:flutter_availability/src/service/local_data_interface.dart";
import "package:flutter_availability/src/ui/widgets/default_base_screen.dart";
import "package:flutter_availability/src/ui/widgets/default_buttons.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Class that holds all options for the availability userstory
class AvailabilityOptions {
  /// AvailabilityOptions constructor where everything is optional.
  AvailabilityOptions({
    this.translations = const AvailabilityTranslations.empty(),
    this.baseScreenBuilder = DefaultBaseScreen.builder,
    this.primaryButtonBuilder = DefaultPrimaryButton.builder,
    this.textButtonBuilder = DefaultTextButton.builder,
    this.spacing = const AvailabilitySpacing(),
    AvailabilityDataInterface? dataInterface,
  }) : dataInterface = dataInterface ?? LocalAvailabilityDataInterface();

  /// The translations for the availability userstory
  final AvailabilityTranslations translations;

  /// The implementation for communicating with the persistance layer
  final AvailabilityDataInterface dataInterface;

  /// A method to wrap your availability screens with a base frame.
  ///
  /// If you provide a screen here make sure to use a [Scaffold], as some
  /// elements require a [Material] or other elements that a [Scaffold]
  /// provides
  final BaseScreenBuilder baseScreenBuilder;

  /// A way to provide your own primary button implementation
  final ButtonBuilder primaryButtonBuilder;

  /// A way to provide your own text button implementation
  final ButtonBuilder textButtonBuilder;

  /// The spacing between elements
  final AvailabilitySpacing spacing;
}

/// All configurable paddings and whitespaces withing the userstory
class AvailabilitySpacing {
  /// Creates an AvailabilitySpacing
  const AvailabilitySpacing({
    this.sidePadding = 32,
    this.bottomButtonPadding = 40,
  });

  /// the padding below the button at the bottom
  final double bottomButtonPadding;

  /// the padding applied on both sides of the screen
  final double sidePadding;
}

/// Builder definition for providing a base screen surrounding each page
typedef BaseScreenBuilder = Widget Function(
  BuildContext context,
  VoidCallback onBack,
  Widget child,
);

/// Builder definition for providing a button implementation
typedef ButtonBuilder = Widget Function(
  BuildContext context,
  FutureOr<void>? Function() onPressed,
  Widget child,
);
