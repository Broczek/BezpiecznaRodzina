import 'dart:async';
import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/screens/zones_screen.dart';

part 'zones_event.dart';
part 'zones_state.dart';

// This BLoC manages the state for the safety zones feature.
// It handles loading, creating, updating, and deleting zones.
// It also listens to the FamilyBloc to keep the user information
// within each zone consistent and up-to-date.
class ZonesBloc extends Bloc<ZonesEvent, ZonesState> {
  final AuthRepository authRepository;
  final FamilyBloc familyBloc;
  late final StreamSubscription _familySubscription;

  ZonesBloc({required this.authRepository, required this.familyBloc})
      : super(ZonesInitial()) {
    on<LoadZones>(_onLoadZones);
    on<AddZone>(_onAddZone);
    on<UpdateZone>(_onUpdateZone);
    on<DeleteZone>(_onDeleteZone);
    on<_UsersUpdated>(_onUsersUpdated);
    on<UserZoneAssignmentChanged>(_onUserZoneAssignmentChanged);

    // Subscribe to the FamilyBloc's stream to react to changes in the user list.
    _familySubscription = familyBloc.stream.listen((state) {
      if (state is FamilyLoaded) {
        // Dispatch an internal event to update zones when users change.
        add(_UsersUpdated(state.members));
      }
    });
  }

  @override
  Future<void> close() {
    _familySubscription.cancel();
    return super.close();
  }

  // Handles loading all zones from the repository.
  Future<void> _onLoadZones(LoadZones event, Emitter<ZonesState> emit) async {
    emit(ZonesLoading());
    try {
      final zones = await authRepository.getZones();
      emit(ZonesLoaded(zones));
    } catch (e) {
      emit(ZonesError(e.toString()));
    }
  }

  // Handles adding a new zone.
  Future<void> _onAddZone(AddZone event, Emitter<ZonesState> emit) async {
    final currentState = state;
    if (currentState is ZonesLoaded) {
      try {
        await authRepository.addZone(event.zone);
        final updatedZones = List<Zone>.from(currentState.zones)..add(event.zone);
        emit(ZoneOperationSuccess(updatedZones));
      } catch (e) {
        emit(ZonesError(e.toString()));
      }
    }
  }

  // Handles updating an existing zone.
  Future<void> _onUpdateZone(
      UpdateZone event, Emitter<ZonesState> emit) async {
    final currentState = state;
    if (currentState is ZonesLoaded) {
       try {
        await authRepository.updateZone(event.zone);
        final updatedZones = currentState.zones.map((zone) {
          return zone.id == event.zone.id ? event.zone : zone;
        }).toList();
        emit(ZoneOperationSuccess(updatedZones));
      } catch (e) {
        emit(ZonesError(e.toString()));
      }
    }
  }

  // Handles deleting a zone.
  Future<void> _onDeleteZone(
      DeleteZone event, Emitter<ZonesState> emit) async {
    final currentState = state;
    if (currentState is ZonesLoaded) {
      try {
        await authRepository.deleteZone(event.zoneId);
        final updatedZones = currentState.zones
            .where((zone) => zone.id != event.zoneId)
            .toList();
        emit(ZoneOperationSuccess(updatedZones));
      } catch (e) {
        emit(ZonesError(e.toString()));
      }
    }
  }
  
  // Handles changes to a single user's zone assignments.
  Future<void> _onUserZoneAssignmentChanged(UserZoneAssignmentChanged event, Emitter<ZonesState> emit) async {
    final currentState = state;
    if (currentState is ZonesLoaded) {
      final username = event.updatedUser.username;
      final newZones = event.updatedUser.assignedZones.toSet();
      final oldZones = event.oldAssignedZones.toSet();

      final zonesAddedTo = newZones.difference(oldZones);
      final zonesRemovedFrom = oldZones.difference(newZones);
      final affectedZoneNames = zonesAddedTo.union(zonesRemovedFrom);

      if (affectedZoneNames.isEmpty) return;

      final updatedZonesList = currentState.zones.map((zone) {
        if (!affectedZoneNames.contains(zone.name)) {
          return zone;
        }

        var usersInZone = zone.usersInfo.split(', ').where((u) => u.isNotEmpty).toSet();

        if (zonesAddedTo.contains(zone.name)) {
          usersInZone.add(username);
        }
        if (zonesRemovedFrom.contains(zone.name)) {
          usersInZone.remove(username);
        }

        final sortedUsers = usersInZone.toList()..sort();
        return zone.copyWith(usersInfo: sortedUsers.join(', '));
      }).toList();

      await authRepository.updateAllZones(updatedZonesList);
      emit(ZonesLoaded(updatedZonesList));
    }
  }

  // Handles updates to the entire user list.
  Future<void> _onUsersUpdated(
    _UsersUpdated event,
    Emitter<ZonesState> emit,
  ) async {
    final currentState = state;
    if (currentState is ZonesLoaded) {
      // Re-calculate the `usersInfo` string for each zone based on the latest user data.
      final updatedZones = currentState.zones.map((zone) {
        final usersInZone = event.users
            .where((user) => user.assignedZones.contains(zone.name))
            .map((user) => user.username)
            .join(', ');
        return zone.copyWith(usersInfo: usersInZone);
      }).toList();
      await authRepository.updateAllZones(updatedZones);

      // FINAL FIX: Preserve the success signal if it was the previous state.
      // This prevents the background sync from overwriting the UI feedback state.
      if (currentState is ZoneOperationSuccess) {
        emit(ZoneOperationSuccess(updatedZones));
      } else {
        emit(ZonesLoaded(updatedZones));
      }
    }
  }
}
