import "package:flutter/material.dart";
import "package:flutter_availability/src/service/availability_service.dart";
import "package:flutter_availability/src/ui/view_models/break_view_model.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

///
class AvailabilityViewModel {
  ///
  const AvailabilityViewModel({
    this.templates = const [],
    this.breaks = const [],
    this.id,
    this.userId,
    this.startTime,
    this.endTime,
    this.clearAvailability = false,
  });

  ///
  factory AvailabilityViewModel.fromModel(
    List<AvailabilityWithTemplate> models,
  ) {
    var model = models.firstOrNull?.availabilityModel;

    var startTime =
        model != null ? TimeOfDay.fromDateTime(model.startDate) : null;
    var endTime = model != null ? TimeOfDay.fromDateTime(model.endDate) : null;
    return AvailabilityViewModel(
      templates: models.getUniqueTemplates(),
      breaks: model?.breaks
              .map(BreakViewModel.fromAvailabilityBreakModel)
              .toList() ??
          [],
      id: model?.id,
      userId: model?.userId,
      startTime: startTime,
      endTime: endTime,
    );
  }

  ///
  final List<AvailabilityTemplateModel> templates;

  ///
  final bool clearAvailability;

  ///
  final TimeOfDay? startTime;

  ///
  final TimeOfDay? endTime;

  ///
  final String? id;

  ///
  final String? userId;

  ///
  final List<BreakViewModel> breaks;

  /// Whether the availability is valid
  bool get isValid => breaks.every((element) => element.isValid);

  /// Whether the save button should be enabled
  bool get canSave =>
      clearAvailability || (startTime != null && endTime != null);

  /// create a AvailabilityModel from the current AvailabilityViewModel
  AvailabilityModel toModel() {
    var startDate = DateTime.now();
    var endDate = DateTime.now();
    return AvailabilityModel(
      id: id,
      userId: userId!,
      startDate: startDate,
      endDate: endDate,
      breaks: breaks.map((e) => e.toBreak()).toList(),
    );
  }

  /// Copies the current properties into a new instance
  /// of [AvailabilityViewModel],
  AvailabilityViewModel copyWith({
    List<AvailabilityTemplateModel>? templates,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? id,
    String? userId,
    List<BreakViewModel>? breaks,
    bool? clearAvailability,
  }) =>
      AvailabilityViewModel(
        templates: templates ?? this.templates,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        breaks: breaks ?? this.breaks,
        clearAvailability: clearAvailability ?? this.clearAvailability,
      );
}
