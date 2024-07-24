import "package:flutter_availability/src/ui/view_models/template_daydata_view_model.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// View model to represent the data during the modification of a week template
class WeekTemplateViewModel {
  /// Constructor
  const WeekTemplateViewModel({
    this.data = const {},
    this.userId,
    this.id,
    this.name,
    this.color,
  });

  /// Create a [WeekTemplateViewModel] from a [AvailabilityTemplateModel]
  factory WeekTemplateViewModel.fromTemplate(
    AvailabilityTemplateModel template,
  ) {
    var data = template.templateData as WeekTemplateData;
    return WeekTemplateViewModel(
      id: template.id,
      userId: template.userId,
      name: template.name,
      color: template.color,
      data: {
        for (var day in WeekDay.values.where(data.data.containsKey))
          day: DayTemplateDataViewModel.fromDayTemplateData(
            data.data[day]!,
          ),
      },
    );
  }

  /// The identifier for this template
  final String? id;

  /// The user id for which the template is created
  final String? userId;

  /// The name by which the template can be visually identified
  final String? name;

  /// The color by which the template can be visually identified
  final int? color;

  /// The data for each day of the week
  final Map<WeekDay, DayTemplateDataViewModel> data;

  /// Whether the data is valid for saving
  /// All days must be valid and there must be at least one day with data
  bool get isValid =>
      data.values.every((e) => e.isValid) && data.values.isNotEmpty;

  /// Whether the save/next button should be enabled
  bool get canSave =>
      color != null && (name?.isNotEmpty ?? false) && data.values.isNotEmpty;

  /// Convert to [AvailabilityTemplateModel] for saving
  AvailabilityTemplateModel toTemplate() => AvailabilityTemplateModel(
        id: id,
        userId: userId ?? "",
        name: name!,
        color: color!,
        templateType: AvailabilityTemplateType.week,
        templateData: WeekTemplateData(
          data: {
            for (var entry in data.entries)
              entry.key: entry.value.toDayTemplateData(),
          },
        ),
      );

  /// Create a copy with new values
  WeekTemplateViewModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? color,
    Map<WeekDay, DayTemplateDataViewModel>? data,
  }) =>
      WeekTemplateViewModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        color: color ?? this.color,
        data: data ?? this.data,
      );
}
