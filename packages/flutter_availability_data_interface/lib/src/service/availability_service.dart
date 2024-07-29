import "package:flutter_availability_data_interface/src/data_interface.dart";
import "package:flutter_availability_data_interface/src/local_repository/local_data_interface.dart";
import "package:flutter_availability_data_interface/src/models/availability.dart";
import "package:flutter_availability_data_interface/src/models/templates.dart";
import "package:flutter_availability_data_interface/src/utils/public.dart";
import "package:rxdart/rxdart.dart";

///
class AvailabilityService {
  ///
  AvailabilityService({
    required this.userId,
    AvailabilityDataInterface? dataInterface,
  }) : dataInterface = dataInterface ?? LocalAvailabilityDataInterface();

  /// The user id for which the availabilities are managed
  final String userId;

  /// The data interface that is used to store and retrieve data
  final AvailabilityDataInterface dataInterface;

  /// Creates a set of availabilities for the given [range], where every
  /// availability is a copy of [availability] with only date information
  /// changed
  Future<void> createAvailability({
    required AvailabilityModel availability,
    required DateRange range,
  }) async {
    // apply the startTime and endTime to the availability model
    var updatedAvailability = availability.copyWith(
      startDate: DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
        availability.startDate.hour,
        availability.startDate.minute,
      ),
      endDate: DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
        availability.endDate.hour,
        availability.endDate.minute,
      ),
      userId: userId,
    );

    availability.validate();

    await dataInterface.setAvailabilitiesForUser(
      userId: userId,
      availability: updatedAvailability,
      start: range.start,
      end: range.end,
    );
  }

  /// removes all the given [availabilities] from the data store
  Future<void> clearAvailabilities(
    List<AvailabilityModel> availabilities,
  ) async {
    for (var availability in availabilities) {
      await dataInterface.deleteAvailabilityForUser(
        userId,
        availability.id!,
      );
    }
  }

  /// Creates a set of availabilities for the given [range] by applying the
  /// [template] to each day in the range
  Future<void> applyTemplate({
    required AvailabilityTemplateModel template,
    required DateRange range,
  }) async {
    await dataInterface.applyTemplateForUser(
      userId,
      template,
      range.start,
      range.end,
    );
  }

  /// Returns a stream where data from availabilities and templates are merged
  Stream<List<AvailabilityWithTemplate>> getOverviewDataForMonth(
    DateTime dayInMonth,
  ) {
    var start = DateTime(dayInMonth.year, dayInMonth.month);
    var end = DateTime(start.year, start.month + 1, 0);

    var availabilityStream = dataInterface.getAvailabilityForUser(
      userId: userId,
      start: start,
      end: end,
    );

    return availabilityStream.switchMap((availabilities) {
      var templateIds = availabilities
          .map((availability) => availability.templateId)
          .whereType<String>()
          .toSet()
          .toList();

      var templatesStream = dataInterface.getTemplatesForUser(
        userId: userId,
        templateIds: templateIds,
      );

      List<AvailabilityWithTemplate> combineTemplateWithAvailability(
        List<AvailabilityModel> availabilities,
        List<AvailabilityTemplateModel> templates,
      ) {
        // create a map to reduce lookup speed to O1
        var templateMap = {
          for (var template in templates) ...{
            template.id: template,
          },
        };

        return [
          for (var availability in availabilities) ...[
            AvailabilityWithTemplate(
              availabilityModel: availability,
              template: templateMap[availability.templateId],
            ),
          ],
        ];
      }

      return Rx.combineLatest2(
        Stream.value(availabilities),
        templatesStream,
        combineTemplateWithAvailability,
      );
    });
  }

  /// Returns a stream of all templates
  Stream<List<AvailabilityTemplateModel>> getTemplates() =>
      dataInterface.getTemplatesForUser(
        userId: userId,
      );

  /// Returns a stream of day templates
  Stream<List<AvailabilityTemplateModel>> getDayTemplates() =>
      getTemplates().map(
        (templates) => templates
            .where(
              (template) =>
                  template.templateType == AvailabilityTemplateType.day,
            )
            .toList(),
      );

  /// Returns a stream of week templates
  Stream<List<AvailabilityTemplateModel>> getWeekTemplates() =>
      getTemplates().map(
        (templates) => templates
            .where(
              (template) =>
                  template.templateType == AvailabilityTemplateType.week,
            )
            .toList(),
      );

  /// Creates a new template
  Future<void> createTemplate(AvailabilityTemplateModel template) async {
    var updatedTemplate = template.copyWith(
      userId: userId,
    );

    template.validate();

    await dataInterface.createTemplateForUser(
      userId,
      updatedTemplate,
    );
  }

  /// Updates a template
  Future<void> updateTemplate(AvailabilityTemplateModel template) async {
    template.validate();

    await dataInterface.updateTemplateForUser(
      userId,
      template.id!,
      template,
    );
  }

  /// Deletes a template
  Future<void> deleteTemplate(AvailabilityTemplateModel template) async {
    await dataInterface.deleteTemplateForUser(
      userId,
      template.id!,
    );
  }
}

/// A combination of availability and template for a single day
class AvailabilityWithTemplate {
  /// Creates
  const AvailabilityWithTemplate({
    required this.availabilityModel,
    required this.template,
  });

  /// the availability
  final AvailabilityModel availabilityModel;

  /// the related template, if any
  final AvailabilityTemplateModel? template;
}

/// Extension to retrieve all unique templates from a combined list
extension RetrieveUniqueTemplates on List<AvailabilityWithTemplate> {
  /// Retrieve all unique templates from a combined list
  List<AvailabilityTemplateModel> getUniqueTemplates() =>
      map((entry) => entry.template)
          .whereType<AvailabilityTemplateModel>()
          .fold(
        <AvailabilityTemplateModel>[],
        (current, template) {
          if (!current.any((other) => other.id == template.id)) {
            return [
              ...current,
              template,
            ];
          }
          return current;
        },
      );
}

/// Extension to retrieve [AvailabilityModel] from a list
/// of [AvailabilityWithTemplate]
extension TransformAvailabilityWithTemplate on List<AvailabilityWithTemplate> {
  /// Retrieve all availabilities from a list of [AvailabilityWithTemplate]
  List<AvailabilityModel> getAvailabilities() =>
      map((entry) => entry.availabilityModel).toList();
}
