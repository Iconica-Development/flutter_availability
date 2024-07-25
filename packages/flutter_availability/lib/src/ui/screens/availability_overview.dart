import "package:flutter/material.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/widgets/base_page.dart";
import "package:flutter_availability/src/ui/widgets/calendar.dart";
import "package:flutter_availability/src/ui/widgets/template_legend.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_hooks/flutter_hooks.dart";

///
class AvailabilityOverview extends StatefulHookWidget {
  ///
  const AvailabilityOverview({
    required this.onEditDateRange,
    required this.onViewTemplates,
    required this.onExit,
    super.key,
  });

  /// Callback for when the user gives an availability range
  final Future<void> Function(
    DateTimeRange range,
    List<AvailabilityWithTemplate> selectedAvailabilities,
  ) onEditDateRange;

  /// Callback for when the user wants to navigate to the overview of templates
  final VoidCallback onViewTemplates;

  /// Callback for when the user wants to navigate back
  final VoidCallback onExit;

  @override
  State<AvailabilityOverview> createState() => _AvailabilityOverviewState();
}

class _AvailabilityOverviewState extends State<AvailabilityOverview> {
  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var availabilityScope = AvailabilityScope.of(context);
    var service = availabilityScope.service;
    var options = availabilityScope.options;
    var translations = options.translations;

    var availabilityStream = useMemoized(
      () => service.getOverviewDataForMonth(_selectedDate),
      [_selectedDate],
    );

    useEffect(() {
      availabilityScope.popHandler.add(widget.onExit);
      return () => availabilityScope.popHandler.remove(widget.onExit);
    });

    var availabilitySnapshot = useStream(availabilityStream);

    var selectedAvailabilities = [
      if (_selectedRange != null) ...[
        ...?availabilitySnapshot.data?.where(
          (item) => item.availabilityModel.isInRange(
            _selectedRange!.start,
            _selectedRange!.end,
          ),
        ),
      ],
    ];

    var availabilitiesAreSelected = selectedAvailabilities.isNotEmpty;

    var title = Center(
      child: Text(
        translations.overviewScreenTitle,
        style: theme.textTheme.displaySmall,
      ),
    );

    var calendar = CalendarView(
      month: _selectedDate,
      onMonthChanged: (month) {
        setState(() {
          _selectedDate = month;
        });
      },
      onEditDateRange: (range) {
        setState(() {
          _selectedRange = range;
        });
      },
      availabilities: availabilitySnapshot,
      selectedRange: _selectedRange,
    );

    var templateLegend = TemplateLegend(
      onViewTemplates: widget.onViewTemplates,
      availabilities: availabilitySnapshot,
    );

    VoidCallback? onButtonPress;
    if (_selectedRange != null) {
      onButtonPress = () async {
        await widget.onEditDateRange(
          _selectedRange!,
          selectedAvailabilities,
        );
        if (mounted) {
          setState(() {
            _selectedRange = null;
          });
        }
      };
    }

    Future<void> onClearButtonClicked() async {
      var isConfirmed = await options.confirmationDialogBuilder(
        context,
        title: translations.clearAvailabilityConfirmTitle,
        description: translations.clearAvailabilityConfirmDescription,
      );
      if (isConfirmed) {
        await service
            .clearAvailabilities(selectedAvailabilities.getAvailabilities());
        setState(() {
          _selectedRange = null;
        });
      }
    }

    var clearSelectedButton = options.bigTextButtonBuilder(
      context,
      onClearButtonClicked,
      Text(translations.clearAvailabilityButton),
    );

    var startEditButton = options.primaryButtonBuilder(
      context,
      onButtonPress,
      Text(translations.editAvailabilityButton),
    );

    return options.baseScreenBuilder(
      context,
      widget.onExit,
      BasePage(
        body: [
          title,
          const SizedBox(height: 24),
          calendar,
          const SizedBox(height: 32),
          templateLegend,
        ],
        buttons: [
          startEditButton,
          if (availabilitiesAreSelected) ...[
            const SizedBox(height: 8),
            clearSelectedButton,
          ],
        ],
      ),
    );
  }
}
