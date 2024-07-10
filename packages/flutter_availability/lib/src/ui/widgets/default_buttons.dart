import "dart:async";

import "package:flutter/material.dart";

///
class DefaultPrimaryButton extends StatelessWidget {
  ///
  const DefaultPrimaryButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  ///
  static Widget builder(
    BuildContext context,
    FutureOr<void> Function()? onPressed,
    Widget child,
  ) =>
      DefaultPrimaryButton(
        onPressed: onPressed,
        child: child,
      );

  ///
  final Widget child;

  ///
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) =>
      FilledButton(onPressed: onPressed, child: child);
}

/// a secondary button with a an outlined border
class DefaultSecondaryButton extends StatelessWidget {
  ///
  const DefaultSecondaryButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  ///
  static Widget builder(
    BuildContext context,
    FutureOr<void> Function()? onPressed,
    Widget child,
  ) =>
      DefaultSecondaryButton(
        onPressed: onPressed,
        child: child,
      );

  ///
  final Widget child;

  ///
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) =>
      OutlinedButton(onPressed: onPressed, child: child);
}

///
class DefaultTextButton extends StatelessWidget {
  ///
  const DefaultTextButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  ///
  static Widget builder(
    BuildContext context,
    FutureOr<void> Function()? onPressed,
    Widget child,
  ) =>
      DefaultTextButton(
        onPressed: onPressed,
        child: child,
      );

  ///
  final Widget child;

  ///
  final FutureOr<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: onPressed, child: child);
}
