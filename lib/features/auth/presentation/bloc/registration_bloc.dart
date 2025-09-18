import 'package:bezpieczna_rodzina/core/models/device_model.dart';
import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'registration_event.dart';
part 'registration_state.dart';

// This BLoC manages the state and logic for the multi-step user registration process.
// It coordinates the flow from entering credentials, verifying a code, to setting up
// the family by adding devices and assigning sub-users.
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc; // To trigger login after successful registration.

  RegistrationBloc({
    required this.authRepository,
    required this.authBloc,
  }) : super(const RegistrationState()) {
    // Register event handlers
    on<RegistrationCompleted>(_onRegistrationCompleted);
    on<RegistrationStepCancelled>(_onStepCancelled);
    on<RegistrationTypeChanged>((event, emit) => emit(state.copyWith(registrationType: event.type)));
    on<RegistrationEmailOrPhoneChanged>((event, emit) => emit(state.copyWith(emailOrPhone: event.value)));
    on<RegistrationUsernameChanged>((event, emit) => emit(state.copyWith(username: event.username)));
    on<RegistrationPasswordChanged>((event, emit) => emit(state.copyWith(password: event.password)));
    on<RegistrationCredentialsSubmitted>(_onCredentialsSubmitted);
    on<RegistrationCodeChanged>((event, emit) => emit(state.copyWith(verificationCode: event.code)));
    on<RegistrationCodeSubmitted>(_onCodeSubmitted);
    on<SearchForDevicesStarted>(_onSearchForDevices);
    on<DeviceAdded>(_onDeviceAdded);
    on<SubUserAssignedToDevice>(_onSubUserAssignedToDevice);
    on<DeviceRemoved>(_onDeviceRemoved);
    on<SubUserUnassigned>(_onSubUserUnassigned);
  }

  // Handles moving back to the previous step in the registration wizard.
  void _onStepCancelled(RegistrationStepCancelled event, Emitter<RegistrationState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  // Handles submission of initial credentials (email/phone, username, password).
  Future<void> _onCredentialsSubmitted(RegistrationCredentialsSubmitted event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(status: RegistrationStatus.loading));
    // Artificial delay removed for testability
    emit(state.copyWith(status: RegistrationStatus.initial, currentStep: 1));
  }

  // Handles submission of the verification code.
  Future<void> _onCodeSubmitted(RegistrationCodeSubmitted event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(status: RegistrationStatus.loading));
    // Artificial delay removed for testability
    if (state.verificationCode == '123456') { // Mock success code
      emit(state.copyWith(status: RegistrationStatus.initial, currentStep: 2));
    } else {
      emit(state.copyWith(status: RegistrationStatus.failure, errorMessage: 'Invalid code'));
      // The error state will be reset by the user's next action, no need for a timed delay.
      // For testing, we can check the failure state directly.
    }
  }

  // Handles the start of a device search.
  Future<void> _onSearchForDevices(SearchForDevicesStarted event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(deviceStatus: DeviceStatus.loading));
    await Future.delayed(const Duration(seconds: 2)); // Mock search delay
    const mockDevices = [
      Device(id: 'd1', name: 'Watch GJD.13 (Tom)', type: DeviceType.watch),
      Device(id: 'd2', name: 'Band BS.07 (Grandma)', type: DeviceType.band),
    ];
    emit(state.copyWith(deviceStatus: DeviceStatus.found, foundDevices: mockDevices));
  }

  // Adds a device from the search results to the list of devices to be registered.
  void _onDeviceAdded(DeviceAdded event, Emitter<RegistrationState> emit) {
    if (state.addedDevices.any((device) => device.id == event.device.id)) {
      emit(state.copyWith(deviceStatus: DeviceStatus.initial, foundDevices: []));
      return;
    }
    final updatedAddedDevices = List<Device>.from(state.addedDevices)..add(event.device);
    emit(state.copyWith(
      addedDevices: updatedAddedDevices,
      deviceStatus: DeviceStatus.initial, 
      foundDevices: [], 
    ));
  }
  
  // Assigns a newly created sub-user to a specific device.
  void _onSubUserAssignedToDevice(SubUserAssignedToDevice event, Emitter<RegistrationState> emit) {
    final updatedList = state.addedDevices.map((device) {
      if (device.id == event.deviceId) {
        return device.copyWith(assignedUser: event.subUser);
      }
      return device;
    }).toList();
    emit(state.copyWith(addedDevices: updatedList));
  }

  // Removes a device from the list during setup.
  void _onDeviceRemoved(DeviceRemoved event, Emitter<RegistrationState> emit) {
    final updatedList = List<Device>.from(state.addedDevices)
      ..removeWhere((device) => device.id == event.deviceId);
    emit(state.copyWith(addedDevices: updatedList));
  }

  // Unassigns a sub-user from a device, making it available again.
  void _onSubUserUnassigned(SubUserUnassigned event, Emitter<RegistrationState> emit) {
    final updatedList = state.addedDevices.map((device) {
      if (device.id == event.deviceId) {
        return device.copyWith(clearAssignedUser: true);
      }
      return device;
    }).toList();
    emit(state.copyWith(addedDevices: updatedList));
  }

  // Finalizes the registration process.
  Future<void> _onRegistrationCompleted(
      RegistrationCompleted event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(status: RegistrationStatus.loading, errorMessage: null));

    try {
      // Call the repository to save the new user and their devices/sub-users.
      await authRepository.completeRegistration(
        username: state.username,
        password: state.password,
        newDevices: state.addedDevices,
      );
      
      // On success, trigger the AuthBloc to log the new user in automatically.
      authBloc.add(AuthLoginRequested(
        username: state.username,
        password: state.password,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: e.toString().replaceFirst("Exception: ", ""),
      ));
    }
  }
}
