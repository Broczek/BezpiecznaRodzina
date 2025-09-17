import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum SubUserRole { standard, viewer }

class SubUser extends Equatable {
  final String id;
  final String username;
  final String password;
  final SubUserRole role;
  final String deviceName;
  final int batteryLevel;
  final List<String> assignedZones;
  final LatLng location;

  const SubUser({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.deviceName,
    required this.batteryLevel,
    this.assignedZones = const [],
    required this.location,
  });

  SubUser copyWith({
    String? id,
    String? username,
    String? password,
    SubUserRole? role,
    String? deviceName,
    int? batteryLevel,
    List<String>? assignedZones,
    LatLng? location,
  }) {
    return SubUser(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      deviceName: deviceName ?? this.deviceName,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      assignedZones: assignedZones ?? this.assignedZones,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        password,
        role,
        deviceName,
        batteryLevel,
        assignedZones,
        location
      ];
}
