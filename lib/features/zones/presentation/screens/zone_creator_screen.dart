import 'dart:async';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:bezpieczna_rodzina/features/zones/data/places_services.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/bloc/zones_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'fullscreen_map_screen.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/screens/zones_screen.dart';
import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';

// A local state class to hold the data for the zone being created or edited.
// This avoids cluttering the BLoC with transient UI state.
class ZoneCreationState {
  String name;
  IconData icon;
  LatLng location;
  double radius;
  Set<String> selectedUsers;
  String address;

  ZoneCreationState({
    this.name = '',
    this.icon = Icons.home_outlined,
    this.location = const LatLng(52.23, 21.01), // Default to Warsaw
    this.radius = 150.0,
    Set<String>? selectedUsers,
    this.address = '',
  }) : selectedUsers = selectedUsers ?? {};
}

// This screen provides a multi-step wizard for creating or editing a safety zone.
// It manages the flow through different steps using a PageView.
class ZoneCreatorScreen extends StatefulWidget {
  // If a zone is passed, the screen operates in "edit" mode. Otherwise, "add" mode.
  final Zone? zoneToEdit;

  const ZoneCreatorScreen({super.key, this.zoneToEdit});

  @override
  State<ZoneCreatorScreen> createState() => _ZoneCreatorScreenState();
}

class _ZoneCreatorScreenState extends State<ZoneCreatorScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  late final ZoneCreationState _zoneState;

  bool get _isEditMode => widget.zoneToEdit != null;

  @override
  void initState() {
    super.initState();
    // Initialize the local state based on whether we are adding or editing.
    if (_isEditMode) {
      final existingZone = widget.zoneToEdit!;
      _zoneState = ZoneCreationState(
        name: existingZone.name,
        icon: existingZone.icon,
        location: existingZone.coordinates,
        radius: existingZone.radius,
        address: existingZone.address,
        selectedUsers:
            existingZone.usersInfo.split(', ').where((u) => u.isNotEmpty).toSet(),
      );

      // Ensure the selected users are still valid.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final familyState = context.read<FamilyBloc>().state;
        if (familyState is FamilyLoaded) {
          final validUserNames =
              familyState.members.map((m) => m.username).toSet();
          _zoneState.selectedUsers
              .removeWhere((user) => !validUserNames.contains(user));
        }
      });
    } else {
      _zoneState = ZoneCreationState();
    }
  }

  // Animates the PageView to the specified step.
  void _goToStep(int step) {
    if (step >= 0 && step <= 3) {
      setState(() => _currentStep = step);
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Finalizes the process by creating or updating the zone.
  void _saveZone() {
    final usersInfo = _zoneState.selectedUsers.join(', ');
    final zone = Zone(
      id: _isEditMode ? widget.zoneToEdit!.id : const Uuid().v4(),
      name: _zoneState.name,
      icon: _zoneState.icon,
      coordinates: _zoneState.location,
      address: _zoneState.address,
      radius: _zoneState.radius,
      usersInfo: usersInfo,
    );

    // Dispatch the appropriate events to the ZonesBloc and FamilyBloc.
    if (_isEditMode) {
      context.read<ZonesBloc>().add(UpdateZone(zone));
      context
          .read<FamilyBloc>()
          .add(UpdateUserAssignmentsForZone(zone.name, _zoneState.selectedUsers));
    } else {
      context.read<ZonesBloc>().add(AddZone(zone));
      context
          .read<FamilyBloc>()
          .add(UpdateUserAssignmentsForZone(zone.name, _zoneState.selectedUsers));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title =
        _isEditMode ? l10n.zoneCreatorEditTitle : l10n.zoneCreatorAddTitle;

    return BlocListener<ZonesBloc, ZonesState>(
      listener: (context, state) {
        if (state is ZoneOperationSuccess) {
          if (mounted) {
            _goToStep(3);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_currentStep == 0) {
                context.pop();
              } else if (_currentStep < 3) {
                _goToStep(_currentStep - 1);
              } else { // On success screen, back goes to the main zones list.
                context.go('/zones');
              }
            },
          ),
        ),
        body: Column(
          children: [
            if (_currentStep < 3) _ProgressIndicator(currentStep: _currentStep),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Name and Icon
                  _Step1(
                    initialName: _zoneState.name,
                    initialIcon: _zoneState.icon,
                    onDataChanged: (name, icon) {
                      setState(() {
                        _zoneState.name = name;
                        _zoneState.icon = icon;
                      });
                    },
                    onNext: () => _goToStep(1),
                  ),
                  // Step 2: Location and Radius
                  _Step2(
                    initialLocation: _zoneState.location,
                    initialRadius: _zoneState.radius,
                    initialAddress: _zoneState.address,
                    onDataChanged: (location, radius, address, cameraPosition) {
                      setState(() {
                        _zoneState.location = location;
                        _zoneState.radius = radius;
                        _zoneState.address = address;
                      });
                    },
                    onNext: () => _goToStep(2),
                  ),
                  // Step 3: User/Device Notifications
                  _Step3(
                    isEditMode: _isEditMode,
                    initialSelection: _zoneState.selectedUsers,
                    onSelectionChanged: (selected) {
                      setState(() {
                        _zoneState.selectedUsers = selected;
                      });
                    },
                    onNext: _saveZone,
                  ),
                  // Step 4: Success Screen
                  _SuccessStep(
                    isEditMode: _isEditMode,
                    onAddAnother: () {
                      setState(() {
                        _zoneState = ZoneCreationState(); // Reset state for a new zone
                      });
                      _goToStep(0);
                    },
                    onFinish: () => context.go('/zones'),
                  ),
                ],
              ),
            ),
            // Delete button is only shown in edit mode.
            if (_isEditMode && _currentStep < 3)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: TextButton.icon(
                  onPressed: _showDeleteConfirmation,
                  icon: Icon(Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error),
                  label: Text(
                    l10n.zoneCreatorDeleteButton,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Shows a confirmation dialog before deleting the zone.
  void _showDeleteConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.zoneCreatorDeleteConfirmTitle),
          content: Text(l10n.zoneCreatorDeleteConfirmContent),
          actions: [
            TextButton(
              child: Text(l10n.searchCancelButton),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(l10n.zoneCreatorDeleteButton,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () {
                context
                    .read<ZonesBloc>()
                    .add(DeleteZone(widget.zoneToEdit!.id));
                context.read<FamilyBloc>().add(
                    UpdateUserAssignmentsForZone(widget.zoneToEdit!.name, {}));
                Navigator.of(dialogContext).pop();
                context.go('/zones');
              },
            ),
          ],
        );
      },
    );
  }
}

// A simple linear progress indicator for the multi-step form.
class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  const _ProgressIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: List.generate(3, (index) {
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

// Widget for Step 1: Zone Name and Icon.
class _Step1 extends StatefulWidget {
  final String initialName;
  final IconData initialIcon;
  final Function(String, IconData) onDataChanged;
  final VoidCallback onNext;

  const _Step1({
    required this.initialName,
    required this.initialIcon,
    required this.onDataChanged,
    required this.onNext,
  });

  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<_Step1> {
  late final TextEditingController _nameController;
  late IconData _selectedIcon;
  final _formKey = GlobalKey<FormState>();

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.work_outline,
    Icons.shopping_cart_outlined,
    Icons.add_location_alt_outlined,
    Icons.bus_alert_outlined,
    Icons.park_outlined,
    Icons.sports_esports_outlined,
    Icons.restaurant_outlined,
    Icons.local_hospital_outlined,
    Icons.king_bed_outlined,
    Icons.music_note_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedIcon = widget.initialIcon;

    _nameController.addListener(() {
      widget.onDataChanged(_nameController.text, _selectedIcon);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            Text(l10n.zoneCreatorStep1Title,
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.zoneCreatorNameLabel,
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? l10n.zoneCreatorNameRequired : null,
            ),
            const SizedBox(height: 32),
            Text(l10n.zoneCreatorSelectIcon, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _icons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedIcon = icon);
                    widget.onDataChanged(_nameController.text, _selectedIcon);
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                    ),
                    child: Icon(icon,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.iconTheme.color),
                  ),
                );
              }).toList(),
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

// Widget for Step 2: Location and Radius selection.
class _Step2 extends StatefulWidget {
  final LatLng initialLocation;
  final double initialRadius;
  final String initialAddress;
  final Function(LatLng, double, String, CameraPosition) onDataChanged;
  final VoidCallback onNext;

  const _Step2({
    required this.initialLocation,
    required this.initialRadius,
    required this.initialAddress,
    required this.onDataChanged,
    required this.onNext,
  });

  @override
  State<_Step2> createState() => _Step2State();
}

class _Step2State extends State<_Step2> {
  late LatLng _selectedLocation;
  late double _radius;
  late final TextEditingController _addressController;
  GoogleMapController? _mapController;
  Timer? _debounce;

  final _suggestionsController = OverlayPortalController();
  final _layerLink = LayerLink();
  late final FocusNode _addressFocusNode;

  final _placesService = PlacesService();
  late final String _sessionToken;
  List<PlaceSuggestion> _addressSuggestions = [];
  bool _isFetchingSuggestions = false;
  bool _isFetchingDetails = false;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _radius = widget.initialRadius;
    _addressController = TextEditingController(text: widget.initialAddress);
    _addressController.addListener(_onAddressChanged);

    _sessionToken = const Uuid().v4();

    _addressFocusNode = FocusNode();
    _addressFocusNode.addListener(() {
      if (!_addressFocusNode.hasFocus) {
        _suggestionsController.hide();
      }
    });

    _cameraPosition = CameraPosition(target: _selectedLocation, zoom: 15);

    if (widget.initialAddress.isEmpty) {
      _updateAddressFromLocation(_selectedLocation, isInitial: true);
    }
  }

  void _onAddressChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchAddress(_addressController.text);
    });
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty || !_addressFocusNode.hasFocus) {
      _suggestionsController.hide();
      return;
    }

    setState(() => _isFetchingSuggestions = true);
    final results = await _placesService.getAutocomplete(query, _sessionToken);
    if (!mounted) return;

    setState(() {
      _addressSuggestions = results;
      _isFetchingSuggestions = false;
    });

    if (results.isNotEmpty && _addressFocusNode.hasFocus) {
      if (!_suggestionsController.isShowing) {
        _suggestionsController.show();
      }
    } else {
      _suggestionsController.hide();
    }
  }

  Future<void> _onSuggestionTapped(PlaceSuggestion suggestion) async {
    FocusScope.of(context).unfocus();
    setState(() => _isFetchingDetails = true);

    final location = await _placesService.getPlaceDetails(suggestion.placeId, _sessionToken);
    if (location == null || !mounted) {
      setState(() => _isFetchingDetails = false);
      return;
    }

    _addressController.removeListener(_onAddressChanged);
    _addressController.text = suggestion.description;
    _addressController.addListener(_onAddressChanged);

    setState(() {
      _selectedLocation = location;
      _isFetchingDetails = false;
    });

    widget.onDataChanged(
        _selectedLocation, _radius, suggestion.description, _cameraPosition);
    _mapController?.animateCamera(CameraUpdate.newLatLng(location));
  }

  @override
  void dispose() {
    _addressController.removeListener(_onAddressChanged);
    _addressController.dispose();
    _addressFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _updateAddressFromLocation(LatLng location,
      {bool isInitial = false}) async {
    final newAddress = await _placesService.getReverseGeocode(location);
    if (!mounted) return;

    if (_addressController.text != newAddress) {
      _addressController.removeListener(_onAddressChanged);
      _addressController.text = newAddress;
      _addressController.addListener(_onAddressChanged);
    }

    if (!isInitial) {
      widget.onDataChanged(location, _radius, newAddress, _cameraPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.zoneCreatorStep2Title,
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) => _mapController = controller,
                      initialCameraPosition: _cameraPosition,
                      onTap: (location) {
                        setState(() => _selectedLocation = location);
                        _updateAddressFromLocation(location);
                      },
                      onCameraMove: (position) {
                        _cameraPosition = position;
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('selected_location'),
                          position: _selectedLocation,
                        ),
                      },
                      circles: {
                        Circle(
                          circleId: const CircleId('radius_circle'),
                          center: _selectedLocation,
                          radius: _radius,
                          fillColor: theme.colorScheme.primary.withOpacity(0.2),
                          strokeColor: theme.colorScheme.primary,
                          strokeWidth: 2,
                        )
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: theme.cardColor.withOpacity(0.8),
                        ),
                        icon: const Icon(Icons.fullscreen),
                        onPressed: _openFullScreenMap,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            CompositedTransformTarget(
              link: _layerLink,
              child: OverlayPortal(
                controller: _suggestionsController,
                overlayChildBuilder: (context) {
                  return CompositedTransformFollower(
                    link: _layerLink,
                    offset: const Offset(0, 68),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 48,
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _isFetchingSuggestions
                              ? const Center(
                                  child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ))
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: _addressSuggestions.length,
                                  itemBuilder: (context, index) {
                                    final suggestion = _addressSuggestions[index];
                                    return ListTile(
                                      title: Text(suggestion.description),
                                      onTap: () => _onSuggestionTapped(suggestion),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  );
                },
                child: TextField(
                  controller: _addressController,
                  focusNode: _addressFocusNode,
                  decoration: InputDecoration(
                    labelText: l10n.zoneCreatorAddressHint,
                    suffixIcon: _isFetchingDetails
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(l10n.zoneCreatorRadius(_radius.toInt()),
                style: theme.textTheme.titleMedium),
            Slider(
              value: _radius,
              min: 50,
              max: 5000,
              divisions: (5000 - 50) ~/ 10,
              label: '${_radius.toInt()} m',
              onChanged: (value) {
                setState(() => _radius = value);
                widget.onDataChanged(_selectedLocation, _radius,
                    _addressController.text, _cameraPosition);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: widget.onNext,
              child: Text(l10n.zoneCreatorNextButton),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullScreenMap() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => FullScreenMapScreen(
          initialCameraPosition: _cameraPosition,
          initialRadius: _radius,
          initialAddress: _addressController.text,
        ),
      ),
    );

    if (result != null &&
        result.containsKey('location') &&
        result.containsKey('cameraPosition') &&
        result.containsKey('radius') &&
        result.containsKey('address')) {
      setState(() {
        _selectedLocation = result['location'];
        _radius = result['radius'];
        _addressController.text = result['address'];
        _cameraPosition = result['cameraPosition'];
      });
      _mapController
          ?.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      widget.onDataChanged(
          _selectedLocation, _radius, _addressController.text, _cameraPosition);
    }
  }
}

// Widget for Step 3: Assigning users for notifications.
class _Step3 extends StatefulWidget {
  final Set<String> initialSelection;
  final ValueChanged<Set<String>> onSelectionChanged;
  final VoidCallback onNext;
  final bool isEditMode;

  const _Step3(
      {required this.initialSelection,
      required this.onSelectionChanged,
      required this.onNext,
      required this.isEditMode});

  @override
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<_Step3> {
  late Set<String> _selectedUsers;

  @override
  void initState() {
    super.initState();
    _selectedUsers = widget.initialSelection;
    widget.onSelectionChanged(_selectedUsers);
  }

  void _toggleUser(String userName) {
    setState(() {
      if (_selectedUsers.contains(userName)) {
        _selectedUsers.remove(userName);
      } else {
        _selectedUsers.add(userName);
      }
    });
    widget.onSelectionChanged(_selectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<FamilyBloc, FamilyState>(
      builder: (context, state) {
        final users = state is FamilyLoaded ? state.members : <SubUser>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.zoneCreatorStep3Title,
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(
                l10n.zoneCreatorStep3Description,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              if (users.isEmpty)
                Center(child: Text(l10n.zoneCreatorNoUsersToAssign))
              else
                ...users.map((user) {
                  final isSelected = _selectedUsers.contains(user.username);
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
                    child: ListTile(
                      onTap: () => _toggleUser(user.username),
                      title: Text(user.username),
                      subtitle: Text(user.deviceName),
                      trailing: isSelected
                          ? Icon(Icons.check_circle,
                              color: theme.colorScheme.primary)
                          : const Icon(Icons.radio_button_unchecked),
                    ),
                  );
                }),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: widget.onNext,
                child: Text(widget.isEditMode
                    ? l10n.familyCreatorSaveChangesButton
                    : l10n.zoneCreatorCreateButton),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget for the final success screen.
class _SuccessStep extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onFinish;
  final VoidCallback onAddAnother;

  const _SuccessStep(
      {required this.isEditMode,
      required this.onFinish,
      required this.onAddAnother});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.check_circle_outline,
              size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            isEditMode
                ? l10n.zoneCreatorSuccessTitleEdit
                : l10n.zoneCreatorSuccessTitleAdd,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.zoneCreatorSuccessDescription,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onFinish,
            child: Text(l10n.zoneCreatorGoToZonesButton),
          ),
          const SizedBox(height: 16),
          if (!isEditMode)
            OutlinedButton(
              onPressed: onAddAnother,
              child: Text(l10n.zoneCreatorAddAnotherButton),
            ),
        ],
      ),
    );
  }
}
