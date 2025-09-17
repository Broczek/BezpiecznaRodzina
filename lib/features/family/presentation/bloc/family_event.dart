part of 'family_bloc.dart';

// Defines the events that can be dispatched to the FamilyBloc.
// These events represent user actions for managing family members,
// such as fetching, adding, updating, or deleting them.
abstract class FamilyEvent extends Equatable {
  const FamilyEvent();
  @override
  List<Object> get props => [];
}

// Event to trigger fetching the list of all family members.
class FetchFamilyData extends FamilyEvent {}

// Event to add a new family member.
class AddFamilyMember extends FamilyEvent {
  final SubUser member;
  const AddFamilyMember(this.member);
  @override
  List<Object> get props => [member];
}

// Event to update an existing family member's details.
class UpdateFamilyMember extends FamilyEvent {
  final SubUser member;
  const UpdateFamilyMember(this.member);
  @override
  List<Object> get props => [member];
}

// Event to delete a family member by their ID.
class DeleteFamilyMember extends FamilyEvent {
  final String memberId;
  const DeleteFamilyMember(this.memberId);
  @override
  List<Object> get props => [memberId];
}

// Event to synchronize a user's zone assignments based on changes made
// in the zone creator screen.
class UpdateUserAssignmentsForZone extends FamilyEvent {
  final String zoneName;
  final Set<String> userNames;
  const UpdateUserAssignmentsForZone(this.zoneName, this.userNames);
  @override
  List<Object> get props => [zoneName, userNames];
}
