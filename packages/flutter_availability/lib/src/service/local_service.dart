import "dart:async";

import "package:flutter_availability_data_interface/flutter_availability_data_interface.dart";

/// A local implementation of the [AvailabilityDataInterface] that stores data
///  in memory.
class LocalAvailabilityDataInterface implements AvailabilityDataInterface {
  final Map<String, List<AvailabilityModel>> _userAvailabilities = {};

  final StreamController<Map<String, List<AvailabilityModel>>>
      _availabilityController = StreamController.broadcast();

  void _notifyChanges() {
    _availabilityController.add(_userAvailabilities);
  }

  @override
  Future<List<AvailabilityModel>> applyTemplateForUser(
    String userId,
    AvailabilityTemplateModel template,
    DateTime start,
    DateTime end,
  ) async {
    // Implementation for applying a template
    throw UnimplementedError();
  }

  @override
  Future<AvailabilityModel> createAvailabilityForUser(
    String userId,
    AvailabilityModel availability,
  ) async {
    var availabilities = _userAvailabilities.putIfAbsent(userId, () => []);
    var newAvailability = availability.copyWith(id: _generateId());
    availabilities.add(newAvailability);
    _notifyChanges();
    return newAvailability;
  }

  @override
  Future<AvailabilityTemplateModel> createTemplateForUser(
    String userId,
    AvailabilityTemplateModel template,
  ) {
    // Implementation for creating a template
    throw UnimplementedError();
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
      _notifyChanges();
    }
  }

  @override
  Future<void> deleteTemplateForUser(String userId, String templateId) {
    // Implementation for deleting a template
    throw UnimplementedError();
  }

  @override
  Stream<List<AvailabilityModel>> getAvailabilityForUser({
    required String userId,
    DateTime? start,
    DateTime? end,
  }) =>
      _availabilityController.stream.map((availabilitiesMap) {
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
      });

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
  ) {
    // Implementation for getting a template by ID
    throw UnimplementedError();
  }

  @override
  Stream<List<AvailabilityTemplateModel>> getTemplatesForUser(String userId) {
    // Implementation for getting all templates for a user
    throw UnimplementedError();
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
        _notifyChanges();
        return availabilities[index];
      }
    }
    throw Exception("Availability not found");
  }

  @override
  Future<AvailabilityTemplateModel> updateTemplateForUser(
    String userId,
    String templateId,
    AvailabilityTemplateModel updatedModel,
  ) {
    // Implementation for updating a template
    throw UnimplementedError();
  }

  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString();
}
