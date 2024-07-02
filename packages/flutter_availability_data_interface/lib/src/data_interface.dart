import "package:flutter_availability_data_interface/src/models/availability.dart";

/// A base interface that defines the communication from the availability user
/// story to its persistance solution.
///
/// This class needs to be implemented for your use case, for example a REST API
/// or a Firebase database.
abstract interface class AvailabilityDataInterface {
  /// Retrieves a list of availabilities for the given [userId].
  ///
  /// Whether this is a one time value or a continuous stream of values is up to
  /// the implementation.
  Stream<List<AvailabilityModel>> getAvailabilityForUser(String userId);

  /// Retrieves a specific availability for the given
  /// [userId] and [availabilityId]
  Stream<AvailabilityModel> getAvailabilityForUserById(
    String userId,
    String availabilityId,
  );

  /// Deletes a specific availability for the given
  /// [userId] and [availabilityId]
  Future<void> deleteAvailabilityForUser(String userId, String availabilityId);

  /// Updates the availability for the given [userId] and [availabilityId]
  ///
  /// This will not work if no [availabilityId] for [userId] exists
  Future<AvailabilityModel> updateAvailabilityForUser(
    String userId,
    String availabilityId,
    AvailabilityModel updatedModel,
  );

  /// Creates a new persistant representation of an availability model
  Future<AvailabilityModel> createAvailabilityForUser(
    String userId,
    AvailabilityModel availability,
  );
}
