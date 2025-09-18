import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/core/models/user_model.dart';
import 'package:bezpieczna_rodzina/core/navigation/app_router.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// This screen displays a list of all family members (SubUsers).
// It fetches data from the FamilyBloc and provides options to manage
// members (add, edit) based on the current user's role.
class FamilyListScreen extends StatefulWidget {
  const FamilyListScreen({super.key});

  @override
  State<FamilyListScreen> createState() => _FamilyListScreenState();
}

class _FamilyListScreenState extends State<FamilyListScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely dispatch the event here. It's called after initState and has access to context.
    // We check the state to ensure we only fetch data once when the screen is first loaded.
    final familyBloc = context.read<FamilyBloc>();
    if (familyBloc.state is FamilyInitial) {
      familyBloc.add(FetchFamilyData());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.familyListTitle),
      ),
      // BlocBuilder rebuilds the UI in response to FamilyState changes.
      body: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          if (state is FamilyInitial || state is FamilyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FamilyLoaded) {
            if (state.members.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildUserList(context, state.members);
          }
          if (state is FamilyError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Start by fetching data.'));
        },
      ),
    );
  }

  // Widget to display when there are no family members.
  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final canManage = authState.user?.role == UserRole.admin;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.people_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              l10n.familyEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.familyEmptyDescription,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (canManage)
              ElevatedButton.icon(
                onPressed: () => context.push('/family-member-creator'),
                icon: const Icon(Icons.add),
                label: Text(l10n.familyAddFirstUserButton),
              ),
          ],
        ),
      ),
    );
  }

  // Widget to build the list of user cards.
  Widget _buildUserList(BuildContext context, List<SubUser> members) {
    final authState = context.watch<AuthBloc>().state;
    final userRole = authState.user?.role;

    if (userRole == null) {
      return const Center(child: Text("User role information is missing."));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      // Add one extra item for the "Add User" button if the user is an Admin.
      itemCount:
          userRole == UserRole.admin ? members.length + 1 : members.length,
      itemBuilder: (context, index) {
        if (userRole == UserRole.admin && index == members.length) {
          return _AddUserCard(
              onPressed: () => context.push('/family-member-creator'));
        }
        final member = members[index];
        // Determine if the current user has permission to manage this member.
        final canManage = userRole == UserRole.admin;

        return _UserCard(member: member, canManage: canManage);
      },
    );
  }
}

// A card widget to display information about a single family member.
class _UserCard extends StatelessWidget {
  final SubUser member;
  final bool canManage;
  const _UserCard({required this.member, required this.canManage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isBatteryLow = member.batteryLevel < 20;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(member.username, style: theme.textTheme.titleLarge),
          ),
          // Embedded Google Map showing the user's location.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                // When tapped, navigate to the zones screen and center on the user.
                targetLocationNotifier.value = member.location;
                GoRouter.of(context).go('/zones');
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 150,
                  // AbsorbPointer prevents interaction with the small map.
                  child: AbsorbPointer(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: member.location,
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('user_location_${member.id}'),
                          position: member.location,
                        ),
                      },
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      scrollGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (member.assignedZones.isNotEmpty)
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: l10n.familyCardInZones(member.assignedZones.join(', ')),
                  ),
                if (member.assignedZones.isNotEmpty) const SizedBox(height: 8),
                _InfoRow(
                  icon: isBatteryLow
                      ? Icons.battery_alert_outlined
                      : Icons.battery_full_outlined,
                  text: l10n.familyCardDeviceInfo(
                      member.batteryLevel, member.deviceName),
                  iconColor: isBatteryLow
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                // Show "Manage" button only if the user has permission.
                if (canManage)
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () =>
                          context.push('/family-member-creator', extra: member),
                      child: Text(l10n.familyManageButton),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// A helper widget for displaying a row with an icon and text.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const _InfoRow({required this.icon, required this.text, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 20,
            color: iconColor ?? Theme.of(context).textTheme.bodySmall?.color),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

// A simple card with a button to add a new user.
class _AddUserCard extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddUserCard({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: Text(l10n.familyAddUserButton),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
