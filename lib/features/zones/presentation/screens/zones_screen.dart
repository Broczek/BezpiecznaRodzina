import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/core/models/user_model.dart';
import 'package:bezpieczna_rodzina/core/navigation/app_router.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/bloc/zones_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// This screen is the main hub for the Safety Zones feature.
// It displays a Google Map with zones and user locations, along with a
// draggable bottom sheet that lists all created zones.
// It features advanced map interactions like custom markers and clustering.

class Zone {
  final String id;
  final String name;
  final IconData icon;
  final String usersInfo;
  final LatLng coordinates;
  final double radius;
  final String address;

  const Zone({
    required this.id,
    required this.name,
    required this.icon,
    required this.usersInfo,
    required this.coordinates,
    required this.radius,
    required this.address,
  });

  Zone copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? usersInfo,
    LatLng? coordinates,
    double? radius,
    String? address,
  }) {
    return Zone(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      usersInfo: usersInfo ?? this.usersInfo,
      coordinates: coordinates ?? this.coordinates,
      radius: radius ?? this.radius,
      address: address ?? this.address,
    );
  }
}

enum SearchResultType { zone, user }

class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final SearchResultType type;
  final IconData icon;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
  });
}

class ZonesScreen extends StatefulWidget {
  const ZonesScreen({super.key});

  @override
  State<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends State<ZonesScreen> {
  // Controllers and Keys for managing UI elements.
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  late GoogleMapController _mapController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final TextEditingController _searchController = TextEditingController();

  // GlobalKeys are used to capture widgets as images for custom map markers.
  final Map<String, GlobalKey> _markerKeys = {};
  final Map<String, GlobalKey> _iconOnlyMarkerKeys = {};
  final Map<int, GlobalKey> _clusterKeys = {};
  final Map<String, GlobalKey> _userMarkerKeys = {};
  final Map<String, GlobalKey> _zoneCardKeys = {}; // For scrolling to a specific card.

  // State variables for map and UI logic.
  String? _highlightedZoneId;
  Set<Marker> _currentMarkers = {};
  bool _areMarkersBuilt = false; // Flag to indicate if custom markers are ready.
  double _currentZoom = 12.0;
  Timer? _debounce;
  bool _isSearching = false;
  String _searchQuery = '';
  List<SearchResult> _searchResults = [];

  // Storage for the pre-rendered marker images (BitmapDescriptors).
  final Map<String, BitmapDescriptor> _fullLabelBitmaps = {};
  final Map<String, BitmapDescriptor> _iconOnlyBitmaps = {};
  final Map<int, BitmapDescriptor> _clusterBitmaps = {};
  final Map<String, BitmapDescriptor> _userBitmaps = {};

  @override
  void initState() {
    super.initState();
    // Load initial data from BLoCs.
    context.read<ZonesBloc>().add(LoadZones());
    context.read<FamilyBloc>().add(FetchFamilyData());
    _searchController.addListener(_onSearchChanged);
    targetLocationNotifier.addListener(_onTargetLocationChanged);

    // Handle initial deep linking to a location.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (targetLocationNotifier.value != null && mounted) {
        _onTargetLocationChanged();
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    targetLocationNotifier.removeListener(_onTargetLocationChanged);
    super.dispose();
  }

  // Animates the map camera to a target location when notified.
  void _onTargetLocationChanged() async {
    final target = targetLocationNotifier.value;
    if (target != null && mounted) {
      final GoogleMapController controller = await _controllerCompleter.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(target, 16.0));
      targetLocationNotifier.value = null; // Reset the notifier.
    }
  }

  // Handles text changes in the search bar to filter zones and users.
  void _onSearchChanged() {
    final l10n = AppLocalizations.of(context)!;
    final query = _searchController.text.toLowerCase();
    if (query == _searchQuery) return;
    _searchQuery = query;

    final zonesState = context.read<ZonesBloc>().state;
    final familyState = context.read<FamilyBloc>().state;
    if (query.isEmpty ||
        zonesState is! ZonesLoaded ||
        familyState is! FamilyLoaded) {
      if (mounted) setState(() => _searchResults = []);
      return;
    }

    final results = <SearchResult>[];
    for (final zone in zonesState.zones) {
      if (zone.name.toLowerCase().contains(query)) {
        results.add(SearchResult(
          id: zone.id,
          title: zone.name,
          subtitle: l10n.zonesSearchResultZone,
          type: SearchResultType.zone,
          icon: zone.icon,
        ));
      }
    }
    for (final user in familyState.members) {
      if (user.username.toLowerCase().contains(query)) {
        results.add(SearchResult(
          id: user.id,
          title: user.username,
          subtitle: l10n.zonesSearchResultUser,
          type: SearchResultType.user,
          icon: Icons.person_outline,
        ));
      }
    }
    if (mounted) setState(() => _searchResults = results);
  }

  // Handles tapping on a search result item.
  void _onSearchResultTapped(SearchResult result) async {
    final zonesState = context.read<ZonesBloc>().state;
    if (zonesState is! ZonesLoaded) return;

    final controller = await _controllerCompleter.future;

    if (result.type == SearchResultType.zone) {
      final zone = zonesState.zones.firstWhere((z) => z.id == result.id);
      controller.animateCamera(CameraUpdate.newLatLngZoom(zone.coordinates, 15.0));
      _onMarkerTapped(zone.id, zonesState.zones);
    } else {
      final familyState = context.read<FamilyBloc>().state;
      if (familyState is FamilyLoaded) {
        final user = familyState.members.firstWhere((u) => u.id == result.id);
        controller.animateCamera(CameraUpdate.newLatLngZoom(user.location, 16.0));
      }
    }

    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  // Captures a widget identified by a GlobalKey and converts it to a PNG image (Uint8List).
  // This is the core of the custom marker generation.
  Future<Uint8List> _captureWidget(GlobalKey key) async {
    await Future.delayed(const Duration(milliseconds: 20)); // Allow widget to render.
    if (!mounted || key.currentContext == null) {
      return Uint8List(0);
    }
    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.5); // Higher pixelRatio for better quality.
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return Uint8List(0);
    return byteData.buffer.asUint8List();
  }

  // Orchestrates the entire custom marker generation process.
  // It first assigns GlobalKeys to all potential markers, then, after they are rendered
  // off-screen, it captures them as images and stores them as BitmapDescriptors.
  Future<void> _prepareAllMarkers(
      List<Zone> zones, List<SubUser> users) async {
    if (!mounted) return;

    // Clear and re-assign keys for all markers to be rendered.
    _zoneCardKeys.clear();
    _markerKeys.clear();
    _iconOnlyMarkerKeys.clear();
    _clusterKeys.clear();
    _userMarkerKeys.clear();

    for (var zone in zones) {
      _zoneCardKeys[zone.id] = GlobalKey();
      _markerKeys[zone.id] = GlobalKey();
      _iconOnlyMarkerKeys[zone.id] = GlobalKey();
    }
    for (int i = 2; i <= zones.length; i++) {
      _clusterKeys[i] = GlobalKey();
    }
    for (var user in users) {
      _userMarkerKeys[user.id] = GlobalKey();
    }

    // After the widgets with these keys are built in the tree (off-screen),
    // capture them as images.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;

      // Capture each widget and convert the resulting bytes to a BitmapDescriptor.
      for (var zone in zones) {
        final fullLabelBytes = await _captureWidget(_markerKeys[zone.id]!);
        if (fullLabelBytes.isNotEmpty) {
          _fullLabelBitmaps[zone.id] =
              BitmapDescriptor.fromBytes(fullLabelBytes);
        }
        final iconOnlyBytes = await _captureWidget(_iconOnlyMarkerKeys[zone.id]!);
        if (iconOnlyBytes.isNotEmpty) {
          _iconOnlyBitmaps[zone.id] = BitmapDescriptor.fromBytes(iconOnlyBytes);
        }
      }
      for (var i = 2; i <= zones.length; i++) {
        if (_clusterKeys.containsKey(i)) {
          final clusterBytes = await _captureWidget(_clusterKeys[i]!);
          if (clusterBytes.isNotEmpty) {
            _clusterBitmaps[i] = BitmapDescriptor.fromBytes(clusterBytes);
          }
        }
      }
      for (var user in users) {
        final userMarkerBytes = await _captureWidget(_userMarkerKeys[user.id]!);
        if (userMarkerBytes.isNotEmpty) {
          _userBitmaps[user.id] = BitmapDescriptor.fromBytes(userMarkerBytes);
        }
      }

      if (mounted) {
        setState(() => _areMarkersBuilt = true);
        // Trigger the first marker update now that the bitmaps are ready.
        _updateMarkersForZoom(_currentZoom, zones, users);
      }
    });
  }

  // Called when the map camera moves. It debounces the call to avoid excessive updates.
  void _onCameraMove(CameraPosition position) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    final zonesState = context.read<ZonesBloc>().state;
    final familyState = context.read<FamilyBloc>().state;

    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted &&
          (_currentZoom != position.zoom || _areMarkersBuilt) &&
          zonesState is ZonesLoaded &&
          familyState is FamilyLoaded) {
        _updateMarkersForZoom(
            position.zoom, zonesState.zones, familyState.members);
      }
    });
  }

  // The main logic to decide whether to show clustered or individual markers based on zoom level.
  void _updateMarkersForZoom(
      double zoom, List<Zone> zones, List<SubUser> users) {
    if (!_areMarkersBuilt) return;
    setState(() => _currentZoom = zoom);

    final Set<Marker> userMarkers = {};
    if (zoom > 10.5) {
      for (final user in users) {
        final bitmap = _userBitmaps[user.id];
        if (bitmap != null) {
          userMarkers.add(Marker(
            markerId: MarkerId('user_${user.id}'),
            position: user.location,
            icon: bitmap,
            anchor: const Offset(0.5, 0.8),
          ));
        }
      }
    }

    if (zoom < 11.5) { // Zoom out: show clusters
      _buildClusterMarkers(zones, userMarkers);
    } else { // Zoom in: show individual markers
      _buildIndividualMarkers(zoom, zones, userMarkers);
    }
  }

  // Builds individual markers for each zone, choosing between full-label and icon-only
  // versions based on the zoom level.
  void _buildIndividualMarkers(
      double zoom, List<Zone> zones, Set<Marker> userMarkers) {
    final markers = <Marker>{};
    for (final zone in zones) {
      final useFullLabel = zoom > 13.5;
      final bitmap =
          useFullLabel ? _fullLabelBitmaps[zone.id] : _iconOnlyBitmaps[zone.id];
      if (bitmap != null) {
        markers.add(Marker(
          markerId: MarkerId(zone.id),
          position: zone.coordinates,
          icon: bitmap,
          anchor: const Offset(0.5, 0.5),
          onTap: () => _onMarkerTapped(zone.id, zones),
        ));
      }
    }
    if (mounted) {
      setState(() => _currentMarkers = markers..addAll(userMarkers));
    }
  }

  // Uses a simple clustering algorithm to group nearby zones into a single cluster marker.
  void _buildClusterMarkers(List<Zone> zones, Set<Marker> userMarkers) async {
    if (!_controllerCompleter.isCompleted) return;

    final clusterManager = FlClusterManager<Zone>(
      zones,
      (zone) => zone.coordinates,
    );

    final screenBounds = await _mapController.getVisibleRegion();
    final clusters =
        await clusterManager.getClusters(_currentZoom, screenBounds);

    final markers = <Marker>{};

    for (final cluster in clusters) {
      if (cluster.isCluster) {
        final bitmap =
            _clusterBitmaps[cluster.count] ?? BitmapDescriptor.defaultMarker;
        markers.add(Marker(
          markerId: MarkerId('cluster_${cluster.id}'),
          position: cluster.location,
          icon: bitmap,
          anchor: const Offset(0.5, 0.5),
          onTap: () => _mapController.animateCamera(
              CameraUpdate.newLatLngZoom(cluster.location, _currentZoom + 1.5)),
        ));
      } else {
        final zone = cluster.points.first;
        final bitmap = _iconOnlyBitmaps[zone.id];
        if (bitmap != null) {
          markers.add(Marker(
            markerId: MarkerId(zone.id),
            position: zone.coordinates,
            icon: bitmap,
            anchor: const Offset(0.5, 0.5),
            onTap: () => _onMarkerTapped(zone.id, zones),
          ));
        }
      }
    }

    if (mounted) {
      setState(() => _currentMarkers = markers..addAll(userMarkers));
    }
  }

  // Handles tapping on a zone marker on the map.
  void _onMarkerTapped(String zoneId, List<Zone> zones) {
    final index = zones.indexWhere((z) => z.id == zoneId);
    if (index == -1) return;

    _sheetController
        .animateTo(0.88,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
        .then((_) {
      final context = _zoneCardKeys[zoneId]?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });

    setState(() => _highlightedZoneId = zoneId);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _highlightedZoneId == zoneId) {
        setState(() => _highlightedZoneId = null);
      }
    });
  }

  // Handles tapping on a zone card in the bottom sheet.
  void _onCardTapped(Zone zone) async {
    _sheetController.animateTo(0.25,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    final controller = await _controllerCompleter.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(zone.coordinates, 15.0));
  }

  @override
  Widget build(BuildContext context) {
    // The main build method assembles the map, draggable sheet, and search bar.
    return MultiBlocListener(
      listeners: [
        // Listen to both BLoCs to trigger marker preparation when data is loaded.
        BlocListener<ZonesBloc, ZonesState>(
          listener: (context, zonesState) {
            final familyState = context.read<FamilyBloc>().state;
            if (zonesState is ZonesLoaded && familyState is FamilyLoaded) {
              _prepareAllMarkers(zonesState.zones, familyState.members);
            }
          },
        ),
        BlocListener<FamilyBloc, FamilyState>(
          listener: (context, familyState) {
            final zonesState = context.read<ZonesBloc>().state;
            if (familyState is FamilyLoaded && zonesState is ZonesLoaded) {
              _prepareAllMarkers(zonesState.zones, familyState.members);
            }
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final userRole = authState.user?.role ?? UserRole.viewer;
          final canManage = userRole == UserRole.admin;

          return BlocBuilder<FamilyBloc, FamilyState>(
            builder: (context, familyState) {
              return BlocBuilder<ZonesBloc, ZonesState>(
                builder: (context, zonesState) {
                  final zones =
                      zonesState is ZonesLoaded ? zonesState.zones : <Zone>[];
                  final users = familyState is FamilyLoaded
                      ? familyState.members
                      : <SubUser>[];

                  return Scaffold(
                    body: Stack(
                      children: [
                        // This off-screen stack holds the widgets that will be captured as markers.
                        // It's translated off-screen so it's not visible to the user.
                        if (!_areMarkersBuilt ||
                            (zonesState is ZonesLoaded &&
                                familyState is FamilyLoaded))
                          Transform.translate(
                            offset:
                                Offset(-MediaQuery.of(context).size.width, 0),
                            child: Stack(
                              children: [
                                // Each RepaintBoundary is necessary for the capture process.
                                ...zones.map((zone) => RepaintBoundary(
                                    key: _markerKeys[zone.id],
                                    child: _ZoneMapLabel(
                                        icon: zone.icon, name: zone.name))),
                                ...zones.map((zone) => RepaintBoundary(
                                    key: _iconOnlyMarkerKeys[zone.id],
                                    child: _ZoneMapIconOnly(icon: zone.icon))),
                                ...List.generate(zones.length, (i) {
                                  final count = i + 2;
                                  if (_clusterKeys.containsKey(count)) {
                                    return RepaintBoundary(
                                        key: _clusterKeys[count],
                                        child: _ClusterMapLabel(count: count));
                                  }
                                  return const SizedBox.shrink();
                                }),
                                ...users.map((user) => RepaintBoundary(
                                    key: _userMarkerKeys[user.id],
                                    child: _UserMapLabel(name: user.username))),
                              ],
                            ),
                          ),
                        // The actual Google Map.
                        GoogleMap(
                          initialCameraPosition: const CameraPosition(
                              target: LatLng(52.23, 21.01), zoom: 12),
                          onMapCreated: (controller) {
                            _mapController = controller;
                            if (!_controllerCompleter.isCompleted) {
                              _controllerCompleter.complete(controller);
                            }
                          },
                          onCameraMove: _onCameraMove,
                          markers: _currentMarkers,
                          circles: {
                            ...zones.map((zone) => Circle(
                                  circleId: CircleId('radius_${zone.id}'),
                                  center: zone.coordinates,
                                  radius: zone.radius,
                                  fillColor: Colors.blue.withAlpha(50),
                                  strokeColor: Colors.blue,
                                  strokeWidth: 1,
                                ))
                          },
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 70),
                        ),
                        // The draggable bottom sheet listing the zones.
                        DraggableScrollableSheet(
                          controller: _sheetController,
                          initialChildSize: 0.25,
                          minChildSize: 0.25,
                          maxChildSize: 0.88,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Container(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        double newSize = _sheetController.size -
                                            (details.delta.dy /
                                                MediaQuery.of(context).size.height);
                                        _sheetController
                                            .jumpTo(newSize.clamp(0.25, 0.88));
                                      },
                                      child: _PanelHeader(
                                        canManage: canManage,
                                        onAddZonePressed: () =>
                                            context.push('/zone-creator'),
                                      ),
                                    ),
                                    Expanded(
                                      child: (zonesState is ZonesLoaded &&
                                              zones.isNotEmpty)
                                          ? ListView.builder(
                                              controller: scrollController,
                                              padding: EdgeInsets.zero,
                                              itemCount: zones.length,
                                              itemBuilder: (context, index) {
                                                final zone = zones[index];
                                                return _ZoneCard(
                                                  key: _zoneCardKeys[zone.id],
                                                  zone: zone,
                                                  isHighlighted:
                                                      _highlightedZoneId ==
                                                          zone.id,
                                                  onTap: () =>
                                                      _onCardTapped(zone),
                                                  canManage: canManage,
                                                );
                                              },
                                            )
                                          : _ZonesEmptyState(
                                              scrollController:
                                                  scrollController),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        // The search bar and search results overlay.
                        SafeArea(
                          child: Column(
                            children: [
                              _SearchBar(
                                isSearching: _isSearching,
                                controller: _searchController,
                                onSearchStateChanged: (isSearching) {
                                  setState(() {
                                    _isSearching = isSearching;
                                    if (!isSearching) _searchController.clear();
                                  });
                                },
                              ),
                              if (_isSearching && _searchQuery.isNotEmpty)
                                _SearchResultsList(
                                  results: _searchResults,
                                  onResultTapped: _onSearchResultTapped,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ZonesEmptyState extends StatelessWidget {
  final ScrollController scrollController;
  const _ZonesEmptyState({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.zonesEmptyTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          _InfoRow(
            icon: Icons.notifications_active_outlined,
            title: l10n.zonesEmptyInfo1Title,
            subtitle: l10n.zonesEmptyInfo1Subtitle,
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.add_location_alt_outlined,
            title: l10n.zonesEmptyInfo2Title,
            subtitle: l10n.zonesEmptyInfo2Subtitle,
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.shield_outlined,
            title: l10n.zonesEmptyInfo3Title,
            subtitle: l10n.zonesEmptyInfo3Subtitle,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoRow(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final bool isSearching;
  final TextEditingController controller;
  final ValueChanged<bool> onSearchStateChanged;

  const _SearchBar({
    required this.isSearching,
    required this.controller,
    required this.onSearchStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final inputDecorationTheme = theme.inputDecorationTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isSearching
          ? TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: l10n.zonesSearchHint,
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: theme.colorScheme.onSurfaceVariant),
                  onPressed: () {
                    onSearchStateChanged(false);
                    FocusScope.of(context).unfocus();
                  },
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear,
                            color: theme.colorScheme.onSurfaceVariant),
                        onPressed: () => controller.clear(),
                      )
                    : null,
                filled: inputDecorationTheme.filled,
                fillColor: inputDecorationTheme.fillColor,
                border: inputDecorationTheme.border,
                enabledBorder: inputDecorationTheme.enabledBorder,
                focusedBorder: inputDecorationTheme.focusedBorder,
                contentPadding: inputDecorationTheme.contentPadding,
              ),
            )
          : InkWell(
              onTap: () => onSearchStateChanged(true),
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.zonesTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Icon(Icons.search,
                        color: theme.colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final List<SearchResult> results;
  final ValueChanged<SearchResult> onResultTapped;

  const _SearchResultsList(
      {required this.results, required this.onResultTapped});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      elevation: 4,
      color: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                leading: Icon(result.icon, color: theme.colorScheme.primary),
                title: Text(result.title),
                subtitle: Text(result.subtitle),
                onTap: () => onResultTapped(result),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  final VoidCallback onAddZonePressed;
  final bool canManage;
  const _PanelHeader(
      {required this.onAddZonePressed, required this.canManage});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (canManage)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ElevatedButton.icon(
                onPressed: onAddZonePressed,
                icon: const Icon(Icons.add),
                label: Text(l10n.zonesAddButton),
              ),
            ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.05),
          ),
        ],
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final Zone zone;
  final bool isHighlighted;
  final VoidCallback onTap;
  final bool canManage;

  const _ZoneCard({
    super.key,
    required this.zone,
    required this.isHighlighted,
    required this.onTap,
    required this.canManage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: isHighlighted
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(zone.icon, size: 28, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(zone.name, style: theme.textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Text('${l10n.zonesCardAddress}:', style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(zone.address, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text('${l10n.zonesCardUsersInZone}:',
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(zone.usersInfo.isEmpty ? l10n.zonesCardNoUsers : zone.usersInfo,
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              if (canManage)
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/zone-creator', extra: zone);
                    },
                    child: Text(l10n.zonesCardModifyButton),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoneMapLabel extends StatelessWidget {
  final IconData icon;
  final String name;

  const _ZoneMapLabel({required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneMapIconOnly extends StatelessWidget {
  final IconData icon;
  const _ZoneMapIconOnly({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ]),
        child:
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _ClusterMapLabel extends StatelessWidget {
  final int count;
  const _ClusterMapLabel({required this.count});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ]),
        child: Text(
          count.toString(),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _UserMapLabel extends StatelessWidget {
  final String name;
  const _UserMapLabel({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              shape: BoxShape.circle,
              border: Border.all(color: theme.cardColor, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                )
              ],
            ),
            child: Icon(Icons.person,
                size: 22, color: theme.colorScheme.onSecondary),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Text(name,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

class FlClusterManager<T> {
  final List<T> _points;
  final LatLng Function(T) _location;
  final int _maxZoom = 21;

  FlClusterManager(this._points, this._location);

  Future<List<Cluster<T>>> getClusters(
      double zoom, LatLngBounds visibleBounds) async {
    final clusters = <Cluster<T>>[];
    final clusterRadius = 150 / (pow(2, zoom));

    final List<Cluster<T>> pointsToCluster = _points.where((p) {
      final location = _location(p);
      return visibleBounds.contains(location);
    }).map((p) => Cluster<T>([p], _location)).toList();

    for (var i = 0; i < pointsToCluster.length; i++) {
      var p = pointsToCluster[i];
      if (p.isConsumed) continue;

      var neighbors = pointsToCluster.sublist(i + 1).where((p2) {
        if (p2.isConsumed) return false;
        final distance = _calculateDistance(p.location, p2.location);
        return distance < clusterRadius;
      }).toList();

      if (neighbors.isEmpty) {
        clusters.add(p);
      } else {
        for (var neighbor in neighbors) {
          neighbor.isConsumed = true;
          p.points.addAll(neighbor.points);
        }
        p.recalculateCentroid();
        clusters.add(p);
      }
    }
    return clusters;
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    final dx = p1.longitude - p2.longitude;
    final dy = p1.latitude - p2.latitude;
    return sqrt(dx * dx + dy * dy);
  }
}

class Cluster<T> {
  List<T> points;
  final LatLng Function(T) _location;
  late LatLng location;
  bool isConsumed = false;
  String get id => points.length == 1
      ? (_location(points.first).latitude.toString() +
          '_' +
          _location(points.first).longitude.toString())
      : location.latitude.toString() + '_' + location.longitude.toString();

  Cluster(this.points, this._location) {
    recalculateCentroid();
  }

  void recalculateCentroid() {
    if (points.isEmpty) return;
    double totalLat = 0, totalLng = 0;
    for (var p in points) {
      totalLat += _location(p).latitude;
      totalLng += _location(p).longitude;
    }
    location = LatLng(totalLat / points.length, totalLng / points.length);
  }

  bool get isCluster => points.length > 1;
  int get count => points.length;
}

