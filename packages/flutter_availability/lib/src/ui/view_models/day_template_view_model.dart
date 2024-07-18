import "package:flutter_availability/src/ui/view_models/template_daydata_view_model.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// View model to represent the data during the modification of a day template
class DayTemplateViewModel {
  /// Constructor
  const DayTemplateViewModel({
    this.data = const DayTemplateDataViewModel(),
    this.id,
    this.userId,
    this.name,
    this.color,
  });

  /// Create a [WeekTemplateViewModel] from a [AvailabilityTemplateModel]
  factory DayTemplateViewModel.fromTemplate(
    AvailabilityTemplateModel template,
  ) {
    var data = template.templateData as DayTemplateData;
    return DayTemplateViewModel(
      id: template.id,
      userId: template.userId,
      name: template.name,
      color: template.color,
      data: DayTemplateDataViewModel.fromDayTemplateData(data),
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

  /// The data for the template day
  final DayTemplateDataViewModel data;

  /// Whether the data is valid for saving
  bool get isValid => data.isValid;

  /// Whether the save/next button should be enabled
  bool get canSave =>
      color != null && (name?.isNotEmpty ?? false) && data.canSave;

  /// Convert to [AvailabilityTemplateModel] for saving
  AvailabilityTemplateModel toTemplate() => AvailabilityTemplateModel(
        id: id,
        userId: userId ?? "",
        name: name!,
        color: color!,
        templateType: AvailabilityTemplateType.day,
        templateData: data.toDayTemplateData(),
      );

  /// Create a copy with new values
  DayTemplateViewModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? color,
    DayTemplateDataViewModel? data,
  }) =>
      DayTemplateViewModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        color: color ?? this.color,
        data: data ?? this.data,
      );
}
