part of 'family_bloc.dart';

// Defines the possible states for the Family feature.
// These states represent the UI's condition, such as loading data,
// displaying a list of family members, or showing an error.
abstract class FamilyState extends Equatable {
  const FamilyState();
  @override
  List<Object> get props => [];
}

// The initial state before any data has been fetched.
class FamilyInitial extends FamilyState {}

// The state indicating that family member data is currently being loaded.
class FamilyLoading extends FamilyState {}

// The state representing that family members have been successfully loaded.
class FamilyLoaded extends FamilyState {
  final List<SubUser> members;
  const FamilyLoaded(this.members);
  @override
  List<Object> get props => [members];
}

// The state indicating that an error occurred while fetching family data.
class FamilyError extends FamilyState {
  final String message;
  const FamilyError(this.message);
  @override
  List<Object> get props => [message];
}
