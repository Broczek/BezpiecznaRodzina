import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/bloc/zones_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

// This screen provides a multi-step interface for creating a new family member (SubUser)
// or editing an existing one. It's a full-screen route.
// Step 1: User details (login, password, role) and device linking.
// Step 2: Assigning the user to existing safety zones.

// A local state class to hold the data being created or edited.
class FamilyMemberState {
  String login;
  String password;
  SubUserRole role;
  String? linkedDevice;
  Set<String> assignedZones;

  FamilyMemberState({
    this.login = '',
    this.password = '',
    this.role = SubUserRole.standard,
    this.linkedDevice,
    Set<String>? assignedZones,
  }) : assignedZones = assignedZones ?? {};
}

class FamilyMemberCreatorScreen extends StatefulWidget {
  // If not null, the screen is in "edit" mode. Otherwise, it's in "add" mode.
  final SubUser? memberToEdit;

  const FamilyMemberCreatorScreen({super.key, this.memberToEdit});

  @override
  State<FamilyMemberCreatorScreen> createState() =>
      _FamilyMemberCreatorScreenState();
}

class _FamilyMemberCreatorScreenState extends State<FamilyMemberCreatorScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  late final FamilyMemberState _memberState;

  bool get _isEditMode => widget.memberToEdit != null;

  @override
  void initState() {
    super.initState();
    // Initialize the local state based on whether we are adding or editing.
    if (_isEditMode) {
      _memberState = FamilyMemberState(
        login: widget.memberToEdit!.username,
        password: widget.memberToEdit!.password,
        role: widget.memberToEdit!.role,
        linkedDevice: widget.memberToEdit!.deviceName,
        assignedZones: widget.memberToEdit!.assignedZones.toSet(),
      );
    } else {
      _memberState = FamilyMemberState();
    }
  }

  // Animates the PageView to the specified step.
  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Called when the user presses the final "Finish" or "Save Changes" button.
  void _onFinish() {
    final member = SubUser(
      id: _isEditMode ? widget.memberToEdit!.id : const Uuid().v4(),
      username: _memberState.login,
      password: _memberState.password,
      role: _memberState.role,
      deviceName: _memberState.linkedDevice ?? 'Unassigned',
      batteryLevel: 100, // Default value
      assignedZones: _memberState.assignedZones.toList(),
      location:
          _isEditMode ? widget.memberToEdit!.location : const LatLng(0, 0),
    );

    // Dispatch the appropriate event to the FamilyBloc.
    if (_isEditMode) {
      context.read<FamilyBloc>().add(UpdateFamilyMember(member));
    } else {
      context.read<FamilyBloc>().add(AddFamilyMember(member));
    }
    context.pop(); // Go back to the previous screen.
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _isEditMode
        ? l10n.familyCreatorEditTitle
        : l10n.familyCreatorAddTitle;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep == 0) {
              context.pop();
            } else {
              _goToStep(_currentStep - 1);
            }
          },
        ),
      ),
      body: Column(
        children: [
          _ProgressIndicator(currentStep: _currentStep),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step1(
                  key: ValueKey('step1_${_isEditMode}'),
                  initialState: _memberState,
                  isEditMode: _isEditMode,
                  onNext: () => _goToStep(1),
                ),
                _Step2(
                  initialState: _memberState,
                  isEditMode: _isEditMode,
                  onFinish: _onFinish,
                ),
              ],
            ),
          ),
          // Show delete button only in edit mode.
          if (_isEditMode)
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: TextButton.icon(
                onPressed: _showDeleteConfirmation,
                icon: Icon(Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error),
                label: Text(
                  l10n.familyCreatorDeleteButton,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Shows a confirmation dialog before deleting the user.
  void _showDeleteConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.familyCreatorDeleteConfirmTitle),
          content: Text(l10n.familyCreatorDeleteConfirmContent),
          actions: [
            TextButton(
              child: Text(l10n.searchCancelButton),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(l10n.familyCreatorDeleteButton,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () {
                context
                    .read<FamilyBloc>()
                    .add(DeleteFamilyMember(widget.memberToEdit!.id));
                Navigator.of(dialogContext).pop();
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// A simple progress indicator for the multi-step form.
class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  const _ProgressIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: List.generate(2, (index) {
          return Expanded(
            child: Container(
              height: 4.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: index < currentStep + 1
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Widget for Step 1: User details and device linking.
class _Step1 extends StatefulWidget {
  final FamilyMemberState initialState;
  final bool isEditMode;
  final VoidCallback onNext;

  const _Step1(
      {super.key,
      required this.initialState,
      required this.isEditMode,
      required this.onNext});

  @override
  __Step1State createState() => __Step1State();
}

class __Step1State extends State<_Step1> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController(text: widget.initialState.login);
    _passwordController =
        TextEditingController(text: widget.initialState.password);
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.familyCreatorStep1Title,
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextFormField(
              controller: _loginController,
              decoration: InputDecoration(labelText: l10n.familyCreatorLoginLabel),
              validator: (v) => v!.isEmpty ? l10n.loginRequiredField : null,
              onChanged: (v) => widget.initialState.login = v,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: l10n.registerPasswordLabel),
              obscureText: true,
              validator: (v) =>
                  v!.length < 6 ? l10n.familyCreatorPasswordMinLength : null,
              onChanged: (v) => widget.initialState.password = v,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SubUserRole>(
              value: widget.initialState.role,
              decoration: InputDecoration(labelText: l10n.assignPermissionsLabel),
              items: SubUserRole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role == SubUserRole.standard
                      ? l10n.assignRoleStandard
                      : l10n.assignRoleViewer),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    widget.initialState.role = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            _DeviceLinker(
              linkedDevice: widget.initialState.linkedDevice,
              onDeviceChanged: (device) {
                setState(() {
                  widget.initialState.linkedDevice = device;
                });
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onNext();
                }
              },
              child: Text(l10n.zoneCreatorNextButton),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Step 2: Assigning the user to zones.
class _Step2 extends StatefulWidget {
  final FamilyMemberState initialState;
  final bool isEditMode;
  final VoidCallback onFinish;

  const _Step2(
      {required this.initialState,
      required this.isEditMode,
      required this.onFinish});

  @override
  __Step2State createState() => __Step2State();
}

class __Step2State extends State<_Step2> {
  late Set<String> _selectedZones;

  @override
  void initState() {
    super.initState();
    _selectedZones = widget.initialState.assignedZones;
  }

  void _toggleZone(String zoneName) {
    setState(() {
      if (_selectedZones.contains(zoneName)) {
        _selectedZones.remove(zoneName);
      } else {
        _selectedZones.add(zoneName);
      }
      widget.initialState.assignedZones = _selectedZones;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ZonesBloc, ZonesState>(
      builder: (context, state) {
        if (state is! ZonesLoaded) {
          // You might want to handle loading/error states for zones here
          return const Center(child: CircularProgressIndicator());
        }

        final zones = state.zones;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.familyCreatorStep2Title,
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(
                l10n.familyCreatorStep2Description,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              if (zones.isEmpty)
                Center(child: Text(l10n.familyCreatorNoZones))
              else
                ...zones.map((zone) {
                  final isSelected = _selectedZones.contains(zone.name);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (_) => _toggleZone(zone.name),
                      title: Text(zone.name),
                      secondary: Icon(zone.icon),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                }),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: widget.onFinish,
                child: Text(widget.isEditMode
                    ? l10n.familyCreatorSaveChangesButton
                    : l10n.familyCreatorFinishButton),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Helper widgets for Device Linking ---

// Manages the UI for linking/unlinking a device.
class _DeviceLinker extends StatelessWidget {
  final String? linkedDevice;
  final ValueChanged<String?> onDeviceChanged;

  const _DeviceLinker(
      {required this.linkedDevice, required this.onDeviceChanged});

  Future<void> _showBluetoothSearchDialog(BuildContext context) async {
    final selectedDevice = await showDialog<String>(
      context: context,
      builder: (context) => const _BluetoothSearchDialog(),
    );
    if (selectedDevice != null) {
      onDeviceChanged(selectedDevice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      elevation: 0,
      child: linkedDevice == null
          ? ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Center(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.bluetooth_searching),
                  label: Text(l10n.familyCreatorLinkDeviceButton),
                  onPressed: () => _showBluetoothSearchDialog(context),
                ),
              ),
            )
          : ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              leading: Icon(Icons.bluetooth_connected,
                  color: theme.colorScheme.primary),
              title:
                  Text(l10n.familyCreatorDeviceLinkedTo, style: theme.textTheme.bodySmall),
              subtitle: Text(linkedDevice!,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'change') {
                    _showBluetoothSearchDialog(context);
                  } else if (value == 'disconnect') {
                    onDeviceChanged(null);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 'change', child: Text(l10n.familyCreatorChangeDevice)),
                  PopupMenuItem(
                      value: 'disconnect',
                      child: Text(l10n.familyCreatorDisconnectDevice)),
                ],
                child: const Icon(Icons.more_vert),
              ),
            ),
    );
  }
}

// A mock dialog for searching for Bluetooth devices.
class _BluetoothSearchDialog extends StatefulWidget {
  const _BluetoothSearchDialog();

  @override
  State<_BluetoothSearchDialog> createState() => _BluetoothSearchDialogState();
}

class _BluetoothSearchDialogState extends State<_BluetoothSearchDialog> {
  bool _isSearching = true;
  final List<String> _foundDevices = [
    'Watch GJD.13',
    'Band BS.07',
    'Phone Family SOS'
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.familyCreatorBluetoothSearchTitle),
      content: SizedBox(
        height: 150,
        width: 300,
        child: _isSearching
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(l10n.familyCreatorBluetoothScanning),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _foundDevices.length,
                itemBuilder: (context, index) {
                  final device = _foundDevices[index];
                  return ListTile(
                    title: Text(device),
                    onTap: () {
                      Navigator.of(context).pop(device);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.searchCancelButton),
        ),
      ],
    );
  }
}
