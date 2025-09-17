part of 'registration_bloc.dart';

// Represents the state of the multi-step user registration process.
// It tracks the current step, user-entered data, device discovery status,
// and any errors that occur during the flow.
enum RegistrationStatus { initial, loading, success, failure }
enum DeviceStatus { initial, loading, found, error }
enum RegistrationType { email, phone }

class RegistrationState extends Equatable {
  // The current step in the registration wizard (0, 1, 2, etc.).
  final int currentStep;
  // The chosen method for registration (email or phone).
  final RegistrationType registrationType;
  // The value of the email or phone number entered by the user.
  final String emailOrPhone;
  // The chosen username.
  final String username;
  // The chosen password.
  final String password;
  // The verification code entered by the user.
  final String verificationCode;
  // The overall status of the registration process.
  final RegistrationStatus status;
  // An error message, if any, to be displayed to the user.
  final String? errorMessage;
  
  // The status of the Bluetooth device search.
  final DeviceStatus deviceStatus;
  // A list of devices found during the search.
  final List<Device> foundDevices;
  // A list of devices the user has added to their account.
  final List<Device> addedDevices;

  const RegistrationState({
    this.currentStep = 0,
    this.registrationType = RegistrationType.email,
    this.emailOrPhone = '',
    this.username = '',
    this.password = '',
    this.verificationCode = '',
    this.status = RegistrationStatus.initial,
    this.errorMessage,
    this.deviceStatus = DeviceStatus.initial,
    this.foundDevices = const [],
    this.addedDevices = const [],
  });

  // Creates a copy of the current state with updated values.
  RegistrationState copyWith({
    int? currentStep,
    RegistrationType? registrationType,
    String? emailOrPhone,
    String? username,
    String? password,
    String? verificationCode,
    RegistrationStatus? status,
    String? errorMessage,
    DeviceStatus? deviceStatus,
    List<Device>? foundDevices,
    List<Device>? addedDevices,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      registrationType: registrationType ?? this.registrationType,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      username: username ?? this.username,
      password: password ?? this.password,
      verificationCode: verificationCode ?? this.verificationCode,
      status: status ?? this.status,
      errorMessage: errorMessage,
      deviceStatus: deviceStatus ?? this.deviceStatus,
      foundDevices: foundDevices ?? this.foundDevices,
      addedDevices: addedDevices ?? this.addedDevices,
    );
  }

  @override
  List<Object?> get props => [
        currentStep, registrationType, emailOrPhone, username, password, 
        verificationCode, status, errorMessage, deviceStatus, 
        foundDevices, addedDevices
      ];
}
