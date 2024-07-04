import "package:flutter/material.dart";
import "package:flutter_availability/src/config/availability_options.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:intl/intl.dart";

///
class AvailabilityOverview extends StatefulWidget {
  ///
  const AvailabilityOverview({
    required this.userId,
    required this.service,
    required this.options,
    required this.onDayClicked,
    required this.onAvailabilityClicked,
    super.key,
  });

  /// The user whose availability is being managed
  final String userId;

  /// The service to use for managing availability
  final AvailabilityDataInterface service;

  /// The configuration option for the availability overview
  final AvailabilityOptions options;

  /// Callback for when the user clicks on a day
  final void Function(DateTime date) onDayClicked;

  /// Callback for when the user clicks on an availability
  final void Function(AvailabilityModel availability) onAvailabilityClicked;

  @override
  State<AvailabilityOverview> createState() => _AvailabilityOverviewState();
}

class _AvailabilityOverviewState extends State<AvailabilityOverview> {
  Stream<List<AvailabilityModel>>? _availabilityStream;

  void _startLoadingAvailabilities(DateTime start, DateTime end) {
    setState(() {
      _availabilityStream = widget.service.getAvailabilityForUser(
        userId: widget.userId,
        start: start,
        end: end,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(
      children: [
        Column(
          children: [
            Text(
              widget.options.translations.calendarTitle,
              style: theme.textTheme.displaySmall,
            ),
            Expanded(
              child: _availabilityStream == null
                  ? const Center(
                      child: Text("Press the button to load availabilities."),
                    )
                  : StreamBuilder<List<AvailabilityModel>>(
                      stream: _availabilityStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("No availabilities found."),
                          );
                        } else {
                          var sortedAvailabilities = snapshot.data!
                            ..sort(
                              (a, b) => a.startDate.compareTo(b.startDate),
                            );
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var availability = sortedAvailabilities[index];
                              return ListTile(
                                title: Text(
                                  "Available from ${DateFormat(
                                    "dd-MM-yyyy HH:mm",
                                  ).format(availability.startDate)} "
                                  "\nto \n"
                                  "${DateFormat("dd-MM-yyyy HH:mm").format(
                                    availability.endDate,
                                  )}",
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    if (availability.id == null) {
                                      return;
                                    }
                                    await widget.service
                                        .deleteAvailabilityForUser(
                                      widget.userId,
                                      availability.id!,
                                    );
                                  },
                                ),
                                onTap: () =>
                                    widget.onAvailabilityClicked(availability),
                              );
                            },
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // ask the user to select a date
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (date == null) {
                    return;
                  }
                  widget.onDayClicked(date);
                },
                child: Text(
                  widget.options.translations.addAvailableDayButtonText,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // ask the user to select a date
                  var dateRange = await showDateRangePicker(
                    context: context,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (dateRange == null) {
                    return;
                  }
                  _startLoadingAvailabilities(dateRange.start, dateRange.end);
                },
                child: const Text("Load availabilities for a date range"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
