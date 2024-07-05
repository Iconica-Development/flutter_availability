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
    this.colors = const AvailabilityColors(),
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

  /// The colors used in the userstory
  final AvailabilityColors colors;
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

/// Contains all the customizable colors for the availability userstory
///
/// If colors are not provided the colors will be taken from the theme
class AvailabilityColors {
  /// Constructor for the AvailabilityColors
  ///
  /// If a color is not provided the color will be taken from the theme
  const AvailabilityColors({
    this.selectedDayColor,
    this.blankDayColor,
    this.outsideMonthTextColor,
    this.textDarkColor,
    this.textLightColor,
    this.templateColors,
  });

  /// The color of the text for the days that are not in the current month
  final Color? outsideMonthTextColor;

  /// The background color of the days that are selected in the calendar
  final Color? selectedDayColor;

  /// The background color of the days in the current month
  /// that have no availability and are not selected
  final Color? blankDayColor;

  /// The color of the text in the calendar when the background has a dark color
  /// This is used to make sure the text is readable on dark backgrounds
  /// If not provided the text color will be white
  final Color? textLightColor;

  /// The color of the text in the calendar when the background has a light
  /// color. This is used to make sure the text is readable on light backgrounds
  /// If not provided the text color will be the theme's text color
  final Color? textDarkColor;

  /// The colors that are used for the templates
  final List<Color>? templateColors;
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
