import "dart:async";

import "package:flutter_availability/src/service/initial_data.dart";
import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// A local implementation of the [AvailabilityDataInterface] that stores data
/// in memory.
class LocalAvailabilityDataInterface implements AvailabilityDataInterface {
  ///
  LocalAvailabilityDataInterface() {
    _notifyAvailabilityChanges();
    _notifyTemplateChanges();
  }

  final Map<String, List<AvailabilityModel>> _userAvailabilities = {
    "": getDefaultLocalAvailabilitiesForUser(),
  };

  final Map<String, List<AvailabilityTemplateModel>> _userTemplates = {
    "": getDefaultLocalTemplatesForUser(),
  };

  final StreamController<Map<String, List<AvailabilityModel>>>
      _availabilityController = StreamController.broadcast();
  final StreamController<Map<String, List<AvailabilityTemplateModel>>>
      _templateController = StreamController.broadcast();

  void _notifyAvailabilityChanges() {
    _availabilityController.add(_userAvailabilities);
  }

  void _notifyTemplateChanges() {
    _templateController.add(_userTemplates);
  }

  @override
  Future<List<AvailabilityModel>> applyTemplateForUser(
    String userId,
    AvailabilityTemplateModel template,
    DateTime start,
    DateTime end,
  ) async {
    var availabilities = template.apply(start, end);
    _userAvailabilities.putIfAbsent(userId, () => []).addAll(availabilities);
    _notifyAvailabilityChanges();
    return availabilities;
  }

  @override
  Future<void> createAvailabilitiesForUser({
    required String userId,
    required AvailabilityModel availability,
    required DateTime start,
    required DateTime end,
  }) async {
    var availabilities = _userAvailabilities.putIfAbsent(userId, () => []);

    var templateData = DayTemplateData(
      startTime: availability.startDate,
      endTime: availability.endDate,
      breaks: availability.breaks,
    );

    var newAvailabilities = templateData.apply(
      start: start,
      end: end,
      userId: userId,
    );

    for (var newAvailability in newAvailabilities) {
      availabilities.add(
        newAvailability.copyWith(
          id: _generateId(),
        ),
      );
    }

    _notifyAvailabilityChanges();
  }

  @override
  Future<AvailabilityTemplateModel> createTemplateForUser(
    String userId,
    AvailabilityTemplateModel template,
  ) async {
    var templates = _userTemplates.putIfAbsent(userId, () => []);
    var newTemplate = template.copyWith(id: _generateId());
    templates.add(newTemplate);
    _notifyTemplateChanges();
    return newTemplate;
  }

  @override
  Future<void> deleteAvailabilityForUser(
    String userId,
    String availabilityId,
  ) async {
    var availabilities = _userAvailabilities[userId];
    if (availabilities != null) {
      availabilities
          .removeWhere((availability) => availability.id == availabilityId);
      _notifyAvailabilityChanges();
    }
  }

  @override
  Future<void> deleteTemplateForUser(String userId, String templateId) async {
    var templates = _userTemplates[userId];
    if (templates != null) {
      templates.removeWhere((template) => template.id == templateId);
      _notifyTemplateChanges();
    }
  }

  @override
  Stream<List<AvailabilityModel>> getAvailabilityForUser({
    required String userId,
    DateTime? start,
    DateTime? end,
  }) {
    // load the availabilities 1 second later to simulate a network request
    Future.delayed(const Duration(seconds: 1), _notifyAvailabilityChanges);

    return _availabilityController.stream
        .map<List<AvailabilityModel>>((availabilitiesMap) {
      var availabilities = availabilitiesMap[userId];
      if (availabilities != null) {
        if (start != null && end != null) {
          return availabilities
              .where(
                (availability) =>
                    availability.startDate.isBefore(end) &&
                    availability.endDate.isAfter(start),
              )
              .toList();
        } else {
          return availabilities;
        }
      } else {
        return [];
      }
    }).handleError((error) => []);
  }

  @override
  Stream<AvailabilityModel> getAvailabilityForUserById(
    String userId,
    String availabilityId,
  ) =>
      _availabilityController.stream.map((availabilitiesMap) {
        var availabilities = availabilitiesMap[userId];
        if (availabilities != null) {
          return availabilities
              .firstWhere((availability) => availability.id == availabilityId);
        } else {
          throw Exception("Availability not found");
        }
      });

  @override
  Stream<AvailabilityTemplateModel> getTemplateForUserById(
    String userId,
    String templateId,
  ) =>
      _templateController.stream.map((templatesMap) {
        var templates = templatesMap[userId];
        if (templates != null) {
          return templates.firstWhere((template) => template.id == templateId);
        } else {
          throw Exception("Template not found");
        }
      });

  @override
  Stream<List<AvailabilityTemplateModel>> getTemplatesForUser({
    required String userId,
    List<String>? templateIds,
  }) {
    // load the templates 1 second later to simulate a network request
    Future.delayed(const Duration(seconds: 1), _notifyTemplateChanges);
    return _templateController.stream.map((templatesMap) {
      var templates = templatesMap[userId];
      if (templateIds != null) {
        return templates
                ?.where((template) => templateIds.contains(template.id))
                .toList() ??
            [];
      } else {
        return templates ?? [];
      }
    }).handleError((error) => []);
  }

  @override
  Future<AvailabilityModel> updateAvailabilityForUser(
    String userId,
    String availabilityId,
    AvailabilityModel updatedModel,
  ) async {
    var availabilities = _userAvailabilities[userId];
    if (availabilities != null) {
      var index = availabilities
          .indexWhere((availability) => availability.id == availabilityId);
      if (index != -1) {
        availabilities[index] = updatedModel.copyWith(id: availabilityId);
        _notifyAvailabilityChanges();
        return availabilities[index];
      }
    }
    // TODO(Joey): Throw proper exceptions here
    throw Exception("Availability not found");
  }

  @override
  Future<AvailabilityTemplateModel> updateTemplateForUser(
    String userId,
    String templateId,
    AvailabilityTemplateModel updatedModel,
  ) async {
    var templates = _userTemplates[userId];
    if (templates != null) {
      var index = templates.indexWhere((template) => template.id == templateId);
      if (index != -1) {
        templates[index] = updatedModel.copyWith(id: templateId);
        _notifyTemplateChanges();
        return templates[index];
      }
    }
    // TODO(Joey): Add proper exceptions in the data interface and throw them
    // here
    throw Exception("Template not found");
  }

  int _id = 1;

  String _generateId() => (_id++).toString();
}
