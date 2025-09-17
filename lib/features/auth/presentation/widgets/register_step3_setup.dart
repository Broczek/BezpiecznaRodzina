import 'package:bezpieczna_rodzina/core/models/device_model.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/widgets/add_subuser_form.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This widget represents the third and final step of the registration process: Family Setup.
// Here, the user can search for and add devices (like watches or bands) and
// assign family members (sub-users) to them before finalizing the account creation.
class RegisterStep3Setup extends StatelessWidget {
  const RegisterStep3Setup({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>
              context.read<RegistrationBloc>().add(RegistrationStepCancelled()),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.setupFamilyTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                l10n.setupFamilyDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              // Button to open the device search dialog.
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.setupSearchDeviceButton),
                onPressed: () => _showSearchDeviceDialog(context),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              // List of devices that have been added.
              Expanded(
                child: BlocBuilder<RegistrationBloc, RegistrationState>(
                  builder: (context, state) {
                    if (state.addedDevices.isEmpty) {
                      return Center(child: Text(l10n.setupNoDevices));
                    }
                    return ListView.builder(
                      itemCount: state.addedDevices.length,
                      itemBuilder: (context, index) {
                        final device = state.addedDevices[index];
                        return _DeviceCard(device: device);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Button to complete the registration.
              BlocBuilder<RegistrationBloc, RegistrationState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.status == RegistrationStatus.loading
                        ? null
                        : () => context
                            .read<RegistrationBloc>()
                            .add(RegistrationCompleted()),
                    child: state.status == RegistrationStatus.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.setupFinishButton),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shows a dialog for searching and selecting devices.
  void _showSearchDeviceDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    context.read<RegistrationBloc>().add(SearchForDevicesStarted());
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<RegistrationBloc>(context),
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (dialogContext, state) {
            return AlertDialog(
              title: Text(l10n.searchDevicesTitle),
              content: SizedBox(
                height: 150,
                width: 300,
                child: _buildDeviceSearchResults(dialogContext, state),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.searchCancelButton),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Builds the content of the device search dialog based on the current state.
  Widget _buildDeviceSearchResults(
      BuildContext context, RegistrationState state) {
    final l10n = AppLocalizations.of(context)!;
    switch (state.deviceStatus) {
      case DeviceStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case DeviceStatus.found:
        // Filter out devices that have already been added.
        final availableDevices = state.foundDevices
            .where((foundDevice) => !state.addedDevices
                .any((addedDevice) => addedDevice.id == foundDevice.id))
            .toList();

        if (availableDevices.isEmpty) {
          return Center(child: Text(l10n.searchDevicesAllAdded));
        }

        return ListView.builder(
          itemCount: availableDevices.length,
          itemBuilder: (context, index) {
            final device = availableDevices[index];
            return ListTile(
              leading: Icon(_getIconForDeviceType(device.type)),
              title: Text(device.name),
              onTap: () {
                context.read<RegistrationBloc>().add(DeviceAdded(device));
                Navigator.of(context).pop();
              },
            );
          },
        );
      case DeviceStatus.error:
        return Center(child: Text(l10n.searchDevicesError));
      default:
        return const Center(child: Text('Start searching.'));
    }
  }

  // Helper to get an icon based on the device type.
  IconData _getIconForDeviceType(DeviceType type) {
    switch (type) {
      case DeviceType.phone:
        return Icons.phone_android;
      case DeviceType.watch:
        return Icons.watch;
      case DeviceType.band:
        return Icons.sensors;
    }
  }
}

// A card widget to display an added device and its assigned user.
class _DeviceCard extends StatelessWidget {
  final Device device;
  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  const RegisterStep3Setup()._getIconForDeviceType(device.type),
                  color: theme.textTheme.bodyLarge?.color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    device.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                // Actions menu for the device (edit, unassign, remove).
                _DeviceActionsMenu(device: device),
              ],
            ),
            const SizedBox(height: 12),
            if (device.assignedUser != null)
              Chip(
                avatar: Icon(Icons.person,
                    size: 16, color: theme.colorScheme.onSecondaryContainer),
                label: Text(
                  l10n.deviceCardUser(device.assignedUser!.username),
                  style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
                ),
                backgroundColor: theme.colorScheme.secondaryContainer,
              )
            else
              TextButton.icon(
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(l10n.deviceCardAssignButton),
                onPressed: () => _showAddSubUserDialog(context, device),
              ),
          ],
        ),
      ),
    );
  }

  // Shows the dialog to add/assign a sub-user.
  void _showAddSubUserDialog(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<RegistrationBloc>(context),
        child: AddSubUserForm(device: device),
      ),
    );
  }
}

// A popup menu for device-specific actions.
class _DeviceActionsMenu extends StatelessWidget {
  const _DeviceActionsMenu({required this.device});
  final Device device;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<RegistrationBloc>();

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit_user') {
          _showAddSubUserDialog(context, device);
        } else if (value == 'unassign_user') {
          bloc.add(SubUserUnassigned(device.id));
        } else if (value == 'remove_device') {
          bloc.add(DeviceRemoved(device.id));
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (device.assignedUser != null)
          PopupMenuItem<String>(
            value: 'edit_user',
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.deviceMenuEditUser),
            ),
          ),
        if (device.assignedUser != null)
          PopupMenuItem<String>(
            value: 'unassign_user',
            child: ListTile(
              leading: const Icon(Icons.link_off),
              title: Text(l10n.deviceMenuUnassignUser),
            ),
          ),
        PopupMenuItem<String>(
          value: 'remove_device',
          child: ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: Text(l10n.deviceMenuRemoveDevice,
                style: const TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  void _showAddSubUserDialog(BuildContext context, Device device) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<RegistrationBloc>(context),
        child: AddSubUserForm(device: device),
      ),
    );
  }
}
