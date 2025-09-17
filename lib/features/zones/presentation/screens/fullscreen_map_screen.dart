import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bezpieczna_rodzina/features/zones/data/places_services.dart';
import 'package:uuid/uuid.dart';

// This screen provides a full-screen map interface for more precise selection
// of a zone's location and radius. It's launched from the ZoneCreatorScreen.
// It allows dragging a marker, tapping to set a location, searching for an address,
// and adjusting the radius with a slider.
class FullScreenMapScreen extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final double initialRadius;
  final String initialAddress;

  const FullScreenMapScreen({
    super.key,
    required this.initialCameraPosition,
    required this.initialRadius,
    required this.initialAddress,
  });

  @override
  State<FullScreenMapScreen> createState() => _FullScreenMapScreenState();
}

class _FullScreenMapScreenState extends State<FullScreenMapScreen> {
  // State variables for map interactions
  late LatLng _selectedLocation;
  late double _radius;
  late final TextEditingController _addressController;
  Timer? _debounce;
  final _suggestionsController = OverlayPortalController();
  final _layerLink = LayerLink();
  late final FocusNode _addressFocusNode;

  // Services for Google Places API
  final _placesService = PlacesService();
  late final String _sessionToken;
  List<PlaceSuggestion> _addressSuggestions = [];
  bool _isFetchingSuggestions = false;
  bool _isFetchingDetails = false;
  CameraPosition? _lastCameraPosition;

  @override
  void initState() {
    super.initState();
    // Initialize state from the widget's parameters.
    _selectedLocation = widget.initialCameraPosition.target;
    _radius = widget.initialRadius;
    _addressController = TextEditingController(text: widget.initialAddress);
    _addressController.addListener(_onAddressChanged);

    _sessionToken = const Uuid().v4(); // For Google Places API session management

    _addressFocusNode = FocusNode();
    _addressFocusNode.addListener(() {
      if (!_addressFocusNode.hasFocus) {
        _suggestionsController.hide(); // Hide suggestions when field loses focus.
      }
    });

    // Fetch address if it wasn't provided initially.
    if (widget.initialAddress.isEmpty) {
      _updateAddressFromLocation(_selectedLocation);
    }
  }
  
  // Debounces address search to avoid excessive API calls while the user is typing.
  void _onAddressChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchAddress(_addressController.text);
    });
  }

  // Fetches address suggestions from the Places API based on the current query.
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

    // Show the suggestions overlay if there are results.
    if (results.isNotEmpty && _addressFocusNode.hasFocus) {
      if (!_suggestionsController.isShowing) {
        _suggestionsController.show();
      }
    } else {
      _suggestionsController.hide();
    }
  }

  // Handles tapping on an address suggestion. Fetches place details and updates the map.
  Future<void> _onSuggestionTapped(PlaceSuggestion suggestion) async {
    FocusScope.of(context).unfocus();
    setState(() => _isFetchingDetails = true);

    final location = await _placesService.getPlaceDetails(suggestion.placeId, _sessionToken);
    if (location == null || !mounted) {
      setState(() => _isFetchingDetails = false);
      return;
    }

    // Update the text field without triggering a new search.
    _addressController.removeListener(_onAddressChanged);
    _addressController.text = suggestion.description;
    _addressController.addListener(_onAddressChanged);

    setState(() {
      _selectedLocation = location;
      _isFetchingDetails = false;
    });
  }

  // Updates the address text field using reverse geocoding based on the selected map location.
  Future<void> _updateAddressFromLocation(LatLng location) async {
    final newAddress = await _placesService.getReverseGeocode(location);
    if (!mounted) return;

    if (_addressController.text != newAddress) {
      _addressController.removeListener(_onAddressChanged);
      _addressController.text = newAddress;
      _addressController.addListener(_onAddressChanged);
    }
  }

  @override
  void dispose() {
    _addressController.removeListener(_onAddressChanged);
    _addressController.dispose();
    _addressFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Callback for when the marker is dragged or the map is tapped.
  void _onLocationChanged(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _updateAddressFromLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // The main Google Map widget.
          GoogleMap(
            initialCameraPosition: widget.initialCameraPosition,
            onCameraMove: (position) {
              _lastCameraPosition = position; // Keep track of the camera position.
            },
            // The circle representing the zone's radius.
            circles: {
              Circle(
                circleId: const CircleId('zone_radius'),
                center: _selectedLocation,
                radius: _radius,
                fillColor: theme.colorScheme.primary.withAlpha(50),
                strokeColor: theme.colorScheme.primary,
                strokeWidth: 1,
              )
            },
            // The draggable marker for the zone's center.
            markers: {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: _selectedLocation,
                draggable: true,
                onDragEnd: (newPosition) => _onLocationChanged(newPosition),
              )
            },
            onTap: _onLocationChanged,
          ),
          // A floating back button.
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          // The bottom card containing controls for address, radius, and confirmation.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Address search text field with suggestions overlay.
                    CompositedTransformTarget(
                      link: _layerLink,
                      child: OverlayPortal(
                        controller: _suggestionsController,
                        overlayChildBuilder: (context) {
                          // ... UI for displaying suggestions ...
                          return CompositedTransformFollower(
                            link: _layerLink,
                            offset: const Offset(0, -208),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Material(
                                elevation: 4.0,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 64,
                                  constraints: const BoxConstraints(maxHeight: 200),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: _isFetchingSuggestions
                                      ? const Center(child: Padding(
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
                            labelText: 'Wpisz adres lub wskaż na mapie',
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
                    const SizedBox(height: 16),
                    // Radius slider.
                    Text('Promień strefy: ${_radius.toInt()} m'),
                    Slider(
                      value: _radius,
                      min: 50,
                      max: 5000,
                      divisions: (5000 - 50) ~/ 10,
                      label: '${_radius.toInt()} m',
                      onChanged: (value) => setState(() => _radius = value),
                    ),
                    const SizedBox(height: 8),
                    // Confirm button to return data to the previous screen.
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop({
                          'location': _selectedLocation,
                          'radius': _radius,
                          'address': _addressController.text,
                          'cameraPosition': _lastCameraPosition ?? widget.initialCameraPosition,
                        });
                      },
                      child: const Text('Zatwierdź'),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

