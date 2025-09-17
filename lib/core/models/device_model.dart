import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:equatable/equatable.dart';

enum DeviceType { phone, watch, band }

class Device extends Equatable {
  final String id;
  final String name;
  final DeviceType type;
  final SubUser? assignedUser;

  const Device({
    required this.id,
    required this.name,
    required this.type,
    this.assignedUser,
  });

  Device copyWith({
    String? id,
    String? name,
    DeviceType? type,
    SubUser? assignedUser,
    bool clearAssignedUser = false,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      assignedUser: clearAssignedUser ? null : assignedUser ?? this.assignedUser,
    );
  }

  @override
  List<Object?> get props => [id, name, type, assignedUser];
}

