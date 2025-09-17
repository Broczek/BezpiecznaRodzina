part of 'registration_bloc.dart';

// Defines the events that can be dispatched to the RegistrationBloc.
// These events correspond to user actions within the multi-step registration flow.
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
  @override
  List<Object> get props => [];
}

// --- Step 1 & 2 Events ---

// Dispatched when the user navigates back to a previous step.
class RegistrationStepCancelled extends RegistrationEvent {}
// Dispatched when the user toggles between email and phone registration.
class RegistrationTypeChanged extends RegistrationEvent {
  final RegistrationType type;
  const RegistrationTypeChanged(this.type);
  @override
  List<Object> get props => [type];
}
// Dispatched when the email/phone input value changes.
class RegistrationEmailOrPhoneChanged extends RegistrationEvent {
  final String value;
  const RegistrationEmailOrPhoneChanged(this.value);
  @override
  List<Object> get props => [value];
}
// Dispatched when the username input value changes.
class RegistrationUsernameChanged extends RegistrationEvent {
  final String username;
  const RegistrationUsernameChanged(this.username);
  @override
  List<Object> get props => [username];
}
// Dispatched when the password input value changes.
class RegistrationPasswordChanged extends RegistrationEvent {
  final String password;
  const RegistrationPasswordChanged(this.password);
  @override
  List<Object> get props => [password];
}
// Dispatched when the user submits their credentials in step 1.
class RegistrationCredentialsSubmitted extends RegistrationEvent {}
// Dispatched when the verification code input value changes.
class RegistrationCodeChanged extends RegistrationEvent {
  final String code;
  const RegistrationCodeChanged(this.code);
  @override
  List<Object> get props => [code];
}
// Dispatched when the user submits the verification code in step 2.
class RegistrationCodeSubmitted extends RegistrationEvent {}

// --- Step 3 Events ---

// Dispatched when the user starts searching for nearby devices.
class SearchForDevicesStarted extends RegistrationEvent {}
// Dispatched when a device is selected from the search results and added.
class DeviceAdded extends RegistrationEvent {
  final Device device;
  const DeviceAdded(this.device);
  @override
  List<Object> get props => [device];
}
// Dispatched when a sub-user is created and assigned to a device.
class SubUserAssignedToDevice extends RegistrationEvent {
  final String deviceId;
  final SubUser subUser;
  const SubUserAssignedToDevice(this.deviceId, this.subUser);
  @override
  List<Object> get props => [deviceId, subUser];
}
// Dispatched when the user finalizes the entire registration process.
class RegistrationCompleted extends RegistrationEvent {}

// Dispatched to remove an already added device during setup.
class DeviceRemoved extends RegistrationEvent {
  final String deviceId;
  const DeviceRemoved(this.deviceId);
  @override
  List<Object> get props => [deviceId];
}

// Dispatched to unassign a sub-user from a device during setup.
class SubUserUnassigned extends RegistrationEvent {
  final String deviceId;
  const SubUserUnassigned(this.deviceId);
  @override
  List<Object> get props => [deviceId];
}
