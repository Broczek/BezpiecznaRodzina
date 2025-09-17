part of 'zones_bloc.dart';

// Defines the possible states for the Zones feature. These states represent
// the UI's condition, such as loading, displaying zones, or an error.
abstract class ZonesState extends Equatable {
  const ZonesState();

  @override
  List<Object> get props => [];
}

// The initial state before any zones have been loaded.
class ZonesInitial extends ZonesState {}

// The state indicating that the list of zones is currently being fetched.
class ZonesLoading extends ZonesState {}

// The state representing that the zones have been successfully loaded.
class ZonesLoaded extends ZonesState {
  final List<Zone> zones;
  const ZonesLoaded(this.zones);

  @override
  List<Object> get props => [zones];
}

// A state that indicates a specific zone operation (add/update/delete) was successful.
// It extends ZonesLoaded so that the UI can still access the list of zones.
class ZoneOperationSuccess extends ZonesLoaded {
  const ZoneOperationSuccess(super.zones);
}

// The state indicating that an error occurred while fetching zones.
class ZonesError extends ZonesState {
  final String message;
  const ZonesError(this.message);

  @override
  List<Object> get props => [message];
}

