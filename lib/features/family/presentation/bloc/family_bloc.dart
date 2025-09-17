import 'package:bezpieczna_rodzina/core/di/injection_container.dart';
import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/bloc/zones_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'family_event.dart';
part 'family_state.dart';

// This BLoC is responsible for managing the state of the family members (SubUsers).
// It handles fetching, adding, updating, and deleting family members,
// interacting with the AuthRepository for data persistence.
class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final AuthRepository authRepository;

  FamilyBloc({required this.authRepository}) : super(FamilyInitial()) {
    on<FetchFamilyData>(_onFetchFamilyData);
    on<AddFamilyMember>(_onAddFamilyMember);
    on<UpdateFamilyMember>(_onUpdateFamilyMember);
    on<DeleteFamilyMember>(_onDeleteFamilyMember);
    on<UpdateUserAssignmentsForZone>(_onUpdateUserAssignmentsForZone);
  }

  // Handles fetching the list of family members from the repository.
  Future<void> _onFetchFamilyData(
      FetchFamilyData event, Emitter<FamilyState> emit) async {
    emit(FamilyLoading());
    try {
      final members = await authRepository.getSubUsers();
      emit(FamilyLoaded(members));
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }

  // Handles adding a new family member.
  Future<void> _onAddFamilyMember(
      AddFamilyMember event, Emitter<FamilyState> emit) async {
    await authRepository.addSubUser(event.member);
    
    // If the new member was assigned to zones, notify the ZonesBloc
    // to update the user counts in those zones.
    if (event.member.assignedZones.isNotEmpty) {
      sl<ZonesBloc>().add(UserZoneAssignmentChanged(
        updatedUser: event.member,
        oldAssignedZones: const [], 
      ));
    }
    
    // Refresh the family list.
    add(FetchFamilyData());
  }

  // Handles updating an existing family member's details.
  Future<void> _onUpdateFamilyMember(
      UpdateFamilyMember event, Emitter<FamilyState> emit) async {
    SubUser? oldMember;
    final currentState = state;
    if (currentState is FamilyLoaded) {
      // Find the old member state to compare zone assignments.
      oldMember = currentState.members.firstWhere((m) => m.id == event.member.id, orElse: () => event.member);
    }
    
    await authRepository.updateUser(event.member);

    // Notify the ZonesBloc of any changes in zone assignments.
    sl<ZonesBloc>().add(UserZoneAssignmentChanged(
      updatedUser: event.member,
      oldAssignedZones: oldMember?.assignedZones ?? [],
    ));

    add(FetchFamilyData());
  }

  // Handles deleting a family member.
  Future<void> _onDeleteFamilyMember(
      DeleteFamilyMember event, Emitter<FamilyState> emit) async {
    SubUser? memberToRemove;
     final currentState = state;
    if (currentState is FamilyLoaded) {
      memberToRemove = currentState.members.where((m) => m.id == event.memberId).cast<SubUser?>().firstOrNull;
    }

    await authRepository.deleteUser(event.memberId);

    // If the removed member was in any zones, notify the ZonesBloc to update them.
    if (memberToRemove != null && memberToRemove.assignedZones.isNotEmpty) {
       sl<ZonesBloc>().add(UserZoneAssignmentChanged(
        updatedUser: memberToRemove.copyWith(assignedZones: []), // The user is now in zero zones.
        oldAssignedZones: memberToRemove.assignedZones,
      ));
    }

    add(FetchFamilyData());
  }

  // Handles updates to user-zone assignments originating from the Zone Creator screen.
  Future<void> _onUpdateUserAssignmentsForZone(
    UpdateUserAssignmentsForZone event,
    Emitter<FamilyState> emit,
  ) async {
    final currentState = state;
    if (currentState is FamilyLoaded) {
      // Iterate through all family members to see if their assignment to the specified zone changed.
      for (var member in currentState.members) {
        final updatedZones = List<String>.from(member.assignedZones);
        final shouldBeAssigned = event.userNames.contains(member.username);
        final isAssigned = updatedZones.contains(event.zoneName);

        if (shouldBeAssigned && !isAssigned) {
          updatedZones.add(event.zoneName);
          await authRepository.updateUser(member.copyWith(assignedZones: updatedZones));
        } 
        else if (!shouldBeAssigned && isAssigned) {
          updatedZones.remove(event.zoneName);
          await authRepository.updateUser(member.copyWith(assignedZones: updatedZones));
        }
      }
      add(FetchFamilyData());
    }
  }
}
