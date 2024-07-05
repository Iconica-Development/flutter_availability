import "package:flutter/material.dart";
import "package:flutter_availability/src/util/scope.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";
import "package:intl/intl.dart";

///
class AvailabilityDayOverview extends StatefulWidget {
  ///
  const AvailabilityDayOverview({
    required this.date,
    required this.onAvailabilitySaved,
    this.initialAvailability,
    super.key,
  });

  /// The date for which the availability is being managed
  final DateTime date;

  /// The initial availability for the day
  final AvailabilityModel? initialAvailability;

  /// Callback for when the availability is saved
  final Function() onAvailabilitySaved;

  @override
  State<AvailabilityDayOverview> createState() =>
      _AvailabilityDayOverviewState();
}

class _AvailabilityDayOverviewState extends State<AvailabilityDayOverview> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late AvailabilityModel _availability;
  bool _clearAvailableToday = false;

  @override
  void initState() {
    super.initState();
    _availability = widget.initialAvailability ??
        AvailabilityModel(
          userId: "",
          startDate: widget.date,
          endDate: widget.date,
          breaks: [],
        );
    _startDateController = TextEditingController(
      text: DateFormat("HH:mm").format(_availability.startDate),
    );
    _endDateController = TextEditingController(
      text: DateFormat("HH:mm").format(_availability.endDate),
    );
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> _selectTime(TextEditingController controller) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
      return picked;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var availabilityScope = AvailabilityScope.of(context);
    var userId = availabilityScope.userId;
    var service = availabilityScope.service;

    Future<void> updateAvailabilityStart() async {
      var selectedTime = await _selectTime(_startDateController);
      if (selectedTime == null) return;

      var updatedStartDate = _availability.startDate.copyWith(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );
      setState(() {
        _availability = _availability.copyWith(startDate: updatedStartDate);
      });
    }

    Future<void> updateAvailabilityEnd() async {
      var selectedTime = await _selectTime(_endDateController);
      if (selectedTime == null) return;

      var updatedEndDate = _availability.endDate.copyWith(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );
      setState(() {
        _availability = _availability.copyWith(endDate: updatedEndDate);
      });
    }

    Future<void> onClickAddPause() async {
      var newBreak = await AvailabilityBreakSelectionDialog.show(context, null);
      if (newBreak != null) {
        setState(() {
          _availability.breaks.add(newBreak);
        });
      }
    }

    Future<void> onClickSave() async {
      if (_clearAvailableToday) {
        // remove the availability for the user
        if (_availability.id != null) {
          await service.dataInterface.deleteAvailabilityForUser(
            userId,
            _availability.id!,
          );
        }
      } else {
        // add an availability for the user
        await service.dataInterface.createAvailabilitiesForUser(
          userId: userId,
          availability: _availability,
          start: widget.date,
          end: widget.date,
        );
      }
      if (context.mounted) {
        widget.onAvailabilitySaved();
      }
    }

    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              DateFormat.yMMMMd().format(widget.date),
              style: theme.textTheme.bodyLarge,
            ),
            Row(
              children: [
                Checkbox(
                  value: _clearAvailableToday,
                  onChanged: (value) {
                    setState(() {
                      _clearAvailableToday = value!;
                    });
                  },
                ),
                const Text("Clear availability for today"),
              ],
            ),
            Opacity(
              opacity: _clearAvailableToday ? 0.5 : 1,
              child: IgnorePointer(
                ignoring: _clearAvailableToday,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: updateAvailabilityStart,
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _startDateController,
                                decoration: const InputDecoration(
                                  labelText: "Begin tijd",
                                  suffixIcon: Icon(Icons.access_time),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text("tot"),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: updateAvailabilityEnd,
                            child: AbsorbPointer(
                              child: TextField(
                                controller: _endDateController,
                                decoration: const InputDecoration(
                                  labelText: "Eind tijd",
                                  suffixIcon: Icon(Icons.access_time),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text("Add pause (optional)"),
                    ListView(
                      shrinkWrap: true,
                      children: _availability.breaks.map(
                        (breakModel) {
                          var start =
                              DateFormat("HH:mm").format(breakModel.startTime);
                          var end =
                              DateFormat("HH:mm").format(breakModel.endTime);
                          return GestureDetector(
                            onTap: () async {
                              var updatedBreak =
                                  await AvailabilityBreakSelectionDialog.show(
                                context,
                                breakModel,
                              );
                              if (updatedBreak != null) {
                                setState(() {
                                  _availability.breaks.remove(breakModel);
                                  _availability.breaks.add(updatedBreak);
                                });
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.lightBlue,
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Text(
                                    "${breakModel.duration.inMinutes}"
                                    " minutes  |  ",
                                  ),
                                  Text(
                                    "$start - "
                                    "$end",
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _availability.breaks.remove(breakModel);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    TextButton(
                      onPressed: onClickAddPause,
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async => onClickSave(),
              child: const Text(""),
            ),
          ],
        ),
      ),
    );
  }
}

///
class AvailabilityBreakSelectionDialog extends StatefulWidget {
  ///
  const AvailabilityBreakSelectionDialog({
    required this.initialBreak,
    super.key,
  });

  /// The initial break to show in the dialog if any
  final AvailabilityBreakModel? initialBreak;

  /// Opens the dialog to add a break
  static Future<AvailabilityBreakModel?> show(
    BuildContext context,
    AvailabilityBreakModel? initialBreak,
  ) async =>
      showDialog<AvailabilityBreakModel>(
        context: context,
        builder: (context) => AvailabilityBreakSelectionDialog(
          initialBreak: initialBreak,
        ),
      );

  @override
  State<AvailabilityBreakSelectionDialog> createState() =>
      _AvailabilityBreakSelectionDialogState();
}

class _AvailabilityBreakSelectionDialogState
    extends State<AvailabilityBreakSelectionDialog> {
  late TextEditingController _durationController;
  late TextEditingController _startPauseController;
  late TextEditingController _endPauseController;
  late AvailabilityBreakModel _breakModel;

  @override
  void initState() {
    super.initState();
    _breakModel = widget.initialBreak ??
        AvailabilityBreakModel(
          startTime: DateTime.now(),
          endTime: DateTime.now(),
        );
    _durationController = TextEditingController(
      text: _breakModel.duration.inMinutes.toString(),
    );
    _startPauseController = TextEditingController(
      text: DateFormat("HH:mm").format(_breakModel.startTime),
    );
    _endPauseController = TextEditingController(
      text: DateFormat("HH:mm").format(_breakModel.endTime),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _startPauseController.dispose();
    _endPauseController.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
      return picked;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    void onUpdateDuration() {
      var duration = int.tryParse(_durationController.text);
      if (duration != null) {
        setState(() {
          _breakModel = _breakModel.copyWith(
            duration: Duration(minutes: duration),
          );
        });
      }
    }

    Future<void> onUpdateStart() async {
      var selectedTime = await _selectTime(context, _startPauseController);
      if (selectedTime == null) return;

      var updatedStartTime = _breakModel.startTime.copyWith(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );
      setState(() {
        _breakModel = _breakModel.copyWith(startTime: updatedStartTime);
      });
    }

    Future<void> onUpdateEnd() async {
      var selectedTime = await _selectTime(context, _endPauseController);
      if (selectedTime == null) return;

      var updatedEndTime = _breakModel.endTime.copyWith(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
      );
      setState(() {
        _breakModel = _breakModel.copyWith(endTime: updatedEndTime);
      });
    }

    return AlertDialog(
      title: const Text("Pauze toevoegen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // textfield for duration in minutes
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: "Duration in minutes",
            ),
            onChanged: (_) => onUpdateDuration(),
          ),
          TextField(
            controller: _startPauseController,
            decoration: const InputDecoration(
              labelText: "Start time",
              suffixIcon: Icon(Icons.access_time),
            ),
            readOnly: true,
            onTap: () async => onUpdateStart(),
          ),
          TextField(
            controller: _endPauseController,
            decoration: const InputDecoration(
              labelText: "End time",
              suffixIcon: Icon(Icons.access_time),
            ),
            readOnly: true,
            onTap: () async => onUpdateEnd(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Save"),
          onPressed: () {
            Navigator.of(context).pop(_breakModel);
          },
        ),
      ],
    );
  }
}
