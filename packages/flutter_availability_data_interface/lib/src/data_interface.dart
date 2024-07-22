import "package:flutter_availability_data_interface/src/models/availability.dart";
import "package:flutter_availability_data_interface/src/models/templates.dart";

/// Exception thrown when the requested availability can not be found
class AvailabilityNotFoundException implements Exception {}

/// Exception thrown when the requested template can not be found
class TemplateNotFoundException implements Exception {}

/// A base interface that defines the communication from the availability user
/// story to its persistance solution.
///
/// This class needs to be implemented for your use case, for example a REST API
/// or a Firebase database.
abstract interface class AvailabilityDataInterface {
  /// Retrieves a list of availabilities for the given [userId].
  ///
  /// Whether this is a one time value or a continuous stream of values is up to
  /// the implementation. The [start] and [end] parameters can be used to filter
  Stream<List<AvailabilityModel>> getAvailabilityForUser({
    required String userId,
    DateTime? start,
    DateTime? end,
  });

  /// Retrieves a specific availability for the given
  /// [userId] and [availabilityId]
  Stream<AvailabilityModel> getAvailabilityForUserById(
    String userId,
    String availabilityId,
  );

  /// Deletes a specific availability for the given
  /// [userId] and [availabilityId]
  Future<void> deleteAvailabilityForUser(String userId, String availabilityId);

  /// Updates the availability for the given [userId] and [availabilityId].
  ///
  /// This will not work if no [availabilityId] for [userId] exists.
  Future<void> updateAvailabilityForUser(
    String userId,
    String availabilityId,
    AvailabilityModel updatedModel,
  );

  /// Creates / Updates availabilities for each day in range [start] ... [end].
  ///
  /// [end] is an inclusive date. [start] and [end] are processed ignoring any
  /// non-date related information.
  Future<void> setAvailabilitiesForUser({
    required String userId,
    required AvailabilityModel availability,
    required DateTime start,
    required DateTime end,
  });

  /// Retrieves a list of templates for the given [userId].
  ///
  /// Whether this is a one time value or a continuous stream of values is up to
  /// the implementation.
  Stream<List<AvailabilityTemplateModel>> getTemplatesForUser({
    required String userId,
    List<String>? templateIds,
  });

  /// Retrieves a specific template for the given
  /// [userId] and [templateId]
  Stream<AvailabilityTemplateModel> getTemplateForUserById(
    String userId,
    String templateId,
  );

  /// Deletes a specific template for the given
  /// [userId] and [templateId]
  Future<void> deleteTemplateForUser(String userId, String templateId);

  /// Updates the availability for the given [userId] and [templateId].
  ///
  /// This will not work if no [templateId] for [userId] exists.
  Future<void> updateTemplateForUser(
    String userId,
    String templateId,
    AvailabilityTemplateModel updatedModel,
  );

  /// Creates a new persistant representation of an availability template model.
  Future<void> createTemplateForUser(
    String userId,
    AvailabilityTemplateModel template,
  );

  /// Applies a given [template] for a [userId] and creates new availabilities.
  Future<void> applyTemplateForUser(
    String userId,
    AvailabilityTemplateModel template,
    DateTime start,
    DateTime end,
  );
}
