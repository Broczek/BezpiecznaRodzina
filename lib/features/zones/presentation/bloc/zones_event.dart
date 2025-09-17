part of 'zones_bloc.dart';

// Defines the events that can be dispatched to the ZonesBloc.
// These events represent user actions or system triggers related
// to managing safety zones.
abstract class ZonesEvent extends Equatable {
  const ZonesEvent();

  @override
  List<Object?> get props => [];
}

// Event to trigger loading the list of all zones.
class LoadZones extends ZonesEvent {}

// Event to add a new zone.
class AddZone extends ZonesEvent {
  final Zone zone;
  const AddZone(this.zone);
  @override
  List<Object> get props => [zone];
}

// Event to update an existing zone.
class UpdateZone extends ZonesEvent {
  final Zone zone;
  const UpdateZone(this.zone);
  @override
  List<Object> get props => [zone];
}

// Event to delete a zone by its ID.
class DeleteZone extends ZonesEvent {
  final String zoneId;
  const DeleteZone(this.zoneId);
  @override
  List<Object> get props => [zoneId];
}

// Internal event dispatched when the list of users is updated in the FamilyBloc.
// This allows the ZonesBloc to synchronize the user info displayed for each zone.
class _UsersUpdated extends ZonesEvent {
  final List<SubUser> users;
  const _UsersUpdated(this.users);
  @override
  List<Object> get props => [users];
}

// Dispatched when a user's zone assignments change (e.g., in the FamilyMemberCreatorScreen).
// This allows the ZonesBloc to update its state to reflect the change.
class UserZoneAssignmentChanged extends ZonesEvent {
  final SubUser updatedUser;
  final List<String> oldAssignedZones;

  const UserZoneAssignmentChanged({required this.updatedUser, required this.oldAssignedZones});

  @override
  List<Object?> get props => [updatedUser, oldAssignedZones];
}
