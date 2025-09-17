import 'dart:math';

import 'package:bezpieczna_rodzina/core/models/device_model.dart';
import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/core/models/user_model.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_exceptions.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/screens/zones_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

// This repository handles all data operations related to authentication and user management.
// It acts as a single source of truth for user, device, and zone data.
// In this implementation, it mocks a backend by storing data in-memory.
class AuthRepository {
  // In-memory storage for the main user, sub-users (family members), and zones.
  User? _currentUser;
  final List<SubUser> _subUsers = [];
  final List<Zone> _zones = [];

  // Mocks a login request.
  Future<dynamic> login(
      {required String username, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency.

    // Check if the credentials match the main user.
    if (_currentUser?.username == username) {
      if (_currentUser!.password == password) {
        return _currentUser;
      } else {
        throw WrongPasswordException();
      }
    }

    // Check if the credentials match any of the sub-users.
    final subUser = _subUsers.cast<SubUser?>().firstWhere(
          (u) => u?.username == username,
          orElse: () => null,
        );

    if (subUser != null) {
      if (subUser.password == password) {
        return subUser;
      } else {
        throw WrongPasswordException();
      }
    }

    // If no user is found, throw an exception.
    throw UserNotFoundException();
  }

  // Mocks the final step of registration.
  Future<User> completeRegistration({
    required String username,
    required String password,
    required List<Device> newDevices,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // Check for username conflicts.
    if (_currentUser?.username == username ||
        _subUsers.any((u) => u.username == username)) {
      throw AuthException('A user with this login already exists.');
    }
    // Create and store the new main user.
    final newMainUser = User(
      id: const Uuid().v4(),
      username: username,
      password: password,
      role: UserRole.admin,
    );
    _currentUser = newMainUser;

    // Extract sub-users from the devices added during registration.
    final newSubUsers = newDevices
        .where((d) => d.assignedUser != null)
        .map((d) => d.assignedUser!)
        .toList();

    // Add new sub-users to the in-memory list.
    for (var subUser in newSubUsers) {
      if (_subUsers.any((u) => u.username == subUser.username)) {
        throw AuthException(
            'A sub-user with the login ${subUser.username} already exists.');
      }
      addSubUser(subUser);
    }
    return newMainUser;
  }

  // Mocks a logout request.
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would clear tokens or session data.
  }

  // Mocks an account recovery request.
  Future<void> recoverAccount(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_currentUser?.username != email &&
        !_subUsers.any((u) => u.username == email)) {
      throw EmailNotFoundException();
    }
    // In a real app, this would trigger a password reset email/SMS.
  }

  // --- Sub-User (Family Member) CRUD Operations ---

  Future<List<SubUser>> getSubUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_subUsers);
  }

  Future<void> addSubUser(SubUser subUser) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_subUsers.any((u) => u.username == subUser.username)) {
      throw AuthException('A user with this login already exists.');
    }
    
    // Assign a random location if not provided, for demonstration purposes.
    SubUser userToAdd = subUser;
    if (subUser.location.latitude == 0 && subUser.location.longitude == 0) {
        final random = Random();
        final lat = 52.2297 + (random.nextDouble() - 0.5) * 0.2; // Warsaw area
        final lng = 21.0122 + (random.nextDouble() - 0.5) * 0.2;
        userToAdd = subUser.copyWith(location: LatLng(lat, lng));
    }
    _subUsers.add(userToAdd);
  }

  Future<void> updateUser(SubUser subUser) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _subUsers.indexWhere((u) => u.id == subUser.id);
    if (index != -1) {
      _subUsers[index] = subUser;
    }
  }

  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _subUsers.removeWhere((u) => u.id == userId);
  }

  // --- Zone CRUD Operations ---

  Future<List<Zone>> getZones() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_zones);
  }

  Future<void> addZone(Zone zone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _zones.add(zone);
  }

  Future<void> updateZone(Zone zone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _zones.indexWhere((z) => z.id == zone.id);
    if (index != -1) {
      _zones[index] = zone;
    }
  }

  // Helper to batch update all zones, used for syncing user info.
  Future<void> updateAllZones(List<Zone> zones) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _zones
      ..clear()
      ..addAll(zones);
  }

  Future<void> deleteZone(String zoneId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _zones.removeWhere((z) => z.id == zoneId);
  }
}
