import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";

///
class BasePage extends StatelessWidget {
  ///
  const BasePage({
    required this.body,
    required this.buttons,
    super.key,
  });

  ///
  final List<Widget> body;

  ///
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var options = availabilityScope.options;
    var spacing = options.spacing;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: spacing.sidePadding),
          sliver: SliverList.list(
            children: [
              const SizedBox(height: 40),
              ...body,
              const SizedBox(height: 32),
            ],
          ),
        ),
        SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sidePadding,
            ).copyWith(
              bottom: spacing.bottomButtonPadding,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(children: buttons),
            ),
          ),
        ),
      ],
    );
  }
}
