import 'package:bezpieczna_rodzina/core/models/device_model.dart';
import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

// This widget is a form presented in a dialog to add or edit a "sub-user"
// (a family member) and assign them to a specific device during the
// registration process. It captures user details like username, password, and role.
class AddSubUserForm extends StatefulWidget {
  // The device to which the new sub-user will be assigned.
  final Device device;
  const AddSubUserForm({super.key, required this.device});

  @override
  State<AddSubUserForm> createState() => _AddSubUserFormState();
}

class _AddSubUserFormState extends State<AddSubUserForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  SubUserRole _role = SubUserRole.standard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.assignToDeviceTitle(widget.device.name)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Username input field.
            TextFormField(
              decoration: InputDecoration(labelText: l10n.assignUsernameLabel),
              onChanged: (value) => _username = value,
              validator: (v) => v!.isEmpty ? l10n.loginRequiredField : null,
            ),
            const SizedBox(height: 16),
            // Password input field.
            TextFormField(
              decoration: InputDecoration(labelText: l10n.assignPasswordLabel),
              obscureText: true,
              onChanged: (value) => _password = value,
              validator: (v) =>
                  v!.length < 6 ? l10n.registerPasswordMinLength : null,
            ),
            const SizedBox(height: 16),
            // Dropdown to select the sub-user's role (e.g., Standard, Viewer).
            DropdownButtonFormField<SubUserRole>(
              value: _role,
              decoration: InputDecoration(labelText: l10n.assignPermissionsLabel),
              items: SubUserRole.values.map((role) {
                return DropdownMenuItem(
                    value: role,
                    child: Text(role == SubUserRole.standard
                        ? l10n.assignRoleStandard
                        : l10n.assignRoleViewer));
              }).toList(),
              onChanged: (value) => setState(() => _role = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.searchCancelButton),
        ),
        ElevatedButton(
          onPressed: () {
            // Validate the form before proceeding.
            if (_formKey.currentState!.validate()) {
              // Create a new SubUser object.
              final subUser = SubUser(
                id: const Uuid().v4(), // Generate a unique ID.
                username: _username,
                password: _password,
                role: _role,
                deviceName: widget.device.name,
                batteryLevel: 100, // Default value.
                location: const LatLng(0, 0), // Default value.
              );
              // Dispatch an event to the RegistrationBloc to assign the new user.
              context
                  .read<RegistrationBloc>()
                  .add(SubUserAssignedToDevice(widget.device.id, subUser));
              Navigator.of(context).pop();
            }
          },
          child: Text(l10n.assignSaveButton),
        ),
      ],
    );
  }
}
