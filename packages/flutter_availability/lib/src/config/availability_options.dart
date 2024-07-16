import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_translations.dart";
import "package:flutter_availability/src/service/local_data_interface.dart";
import "package:flutter_availability/src/ui/widgets/default_base_screen.dart";
import "package:flutter_availability/src/ui/widgets/default_buttons.dart";
import "package:flutter_availability/src/ui/widgets/default_confirmation_dialog.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// Class that holds all options for the availability userstory
class AvailabilityOptions {
  /// AvailabilityOptions constructor where everything is optional.
  AvailabilityOptions({
    this.translations = const AvailabilityTranslations.empty(),
    this.baseScreenBuilder = DefaultBaseScreen.builder,
    this.primaryButtonBuilder = DefaultPrimaryButton.builder,
    this.secondaryButtonBuilder = DefaultSecondaryButton.builder,
    this.bigTextButtonBuilder = DefaultBigTextButton.builder,
    this.smallTextButtonBuilder = DefaultSmallTextButton.builder,
    this.bigTextButtonWrapperBuilder = DefaultBigTextButtonWrapper.builder,
    this.spacing = const AvailabilitySpacing(),
    this.textStyles = const AvailabilityTextStyles(),
    this.colors = const AvailabilityColors(),
    this.confirmationDialogBuilder = DefaultConfirmationDialog.builder,
    this.timePickerBuilder,
    // TODO(Joey): Also have a DefaultLoader.builder
    this.loadingIndicatorBuilder = defaultLoader,
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

  /// A way to provide your own secondary button implementation
  final ButtonBuilder secondaryButtonBuilder;

  /// A way to provide your own big text button implementation
  /// This is used as a tertiary button
  final ButtonBuilder bigTextButtonBuilder;

  /// A way to provide your own small text button implementation
  /// This is used as a smaller variant of the tertiary button
  final ButtonBuilder smallTextButtonBuilder;

  /// A way to provide your own element wrapper for the [bigTextButtonBuilder]
  /// On some screens this button is wrapped in a container with a padding
  final ButtonBuilder bigTextButtonWrapperBuilder;

  /// The spacing between elements
  final AvailabilitySpacing spacing;

  /// The configurable text styles in the userstory
  final AvailabilityTextStyles textStyles;

  /// The colors used in the userstory
  final AvailabilityColors colors;

  /// A way to provide your own confirmation dialog implementation
  /// If not provided the [DefaultConfirmationDialog.builder] will be used
  /// which shows a modal bottom sheet with a title and a description
  final ConfirmationDialogBuilder confirmationDialogBuilder;

  /// A way to provide your own time picker implementation or customize
  /// the default time picker
  final TimePickerBuilder? timePickerBuilder;

  /// A builder to override the loading indicator
  /// If not provided the [CircularProgressIndicator.adaptive()] will be used
  /// which shows a platform adaptive loading indicator
  final WidgetBuilder loadingIndicatorBuilder;
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

/// All customizable text styles for the availability userstory
/// If text styles are not provided the text styles will be taken from the theme
class AvailabilityTextStyles {
  /// Constructor for the AvailabilityTextStyles
  const AvailabilityTextStyles({
    this.inputFieldTextStyle,
  });

  /// The text style for the filled in text on all the input fields
  final TextStyle? inputFieldTextStyle;
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
    this.customAvailabilityColor,
    this.blankDayColor,
    this.outsideMonthTextColor,
    this.textDarkColor,
    this.textLightColor,
    this.templateWeekOverviewBackgroundColor,
    this.templateColors = const [
      Color(0xFF9bb8f2),
      Color(0xFF4b77d0),
      Color(0xFF283a5e),
      Color(0xFF57947d),
      Color(0xFFef6c75),
      Color(0xFFb7198b),
    ],
  });

  /// The color of the text for the days that are not in the current month
  final Color? outsideMonthTextColor;

  /// The background color of the days that are selected in the calendar
  final Color? selectedDayColor;

  /// The background color of the days that have an availability without a
  /// template. This color is also shown when a template has been deleted.
  /// If not provided the color will be the theme's
  final Color? customAvailabilityColor;

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

  /// The color of the background in the template week overview that creates a 
  /// layered effect by interchanging a color and a transparent color
  /// If not provided the color will be the theme's [ColorScheme.surface]
  final Color? templateWeekOverviewBackgroundColor;

  /// The colors that are used for the templates
  final List<Color> templateColors;
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
  FutureOr<void>? Function()? onPressed,
  Widget child,
);

/// Builder definition for providing a time picker implementation
typedef TimePickerBuilder = Future<TimeOfDay?> Function(
  BuildContext context,
  TimeOfDay? initialTime,
);

/// Builder definition for providing a custom confirmation dialog
///
/// The function should return a [Future] that resolves to `true` if the user
/// confirms.
typedef ConfirmationDialogBuilder = Future<bool?> Function(
  BuildContext context, {
  required String title,
  required String description,
});

/// Builder definition for providing a loading indicator implementation
Widget defaultLoader(
  BuildContext context,
) =>
    const CircularProgressIndicator.adaptive();
