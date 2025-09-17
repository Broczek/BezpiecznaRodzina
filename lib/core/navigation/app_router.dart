// File-level: Application routing configuration for navigation using go_router.
// This file defines the app's navigation structure, route handlers, and
// redirect rules based on authentication state.

import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/screens/login_screen.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/screens/recovery_screen.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/screens/register_screen.dart';
import 'package:bezpieczna_rodzina/features/home_map/presentation/screens/home_screen.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/screens/family_list_screen.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/screens/family_member_creator_screen.dart';
import 'package:bezpieczna_rodzina/features/menu/presentation/screens/menu_screen.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/screens/zones_screen.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/screens/zone_creator_screen.dart';
import 'package:bezpieczna_rodzina/features/shell/presentation/screens/main_shell_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Notifier: holds an optional LatLng used when user selects a target location on the map.
// Other widgets can listen to this ValueNotifier to react to location changes.
final ValueNotifier<LatLng?> targetLocationNotifier = ValueNotifier(null);

// Router factory: builds a GoRouter wired to the provided AuthBloc.
// The router uses the bloc's stream to refresh (so redirects react to auth changes).
GoRouter appRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    // Refresh GoRouter whenever the authentication bloc emits a new state.
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      // Public home route (could be a landing page or map view).
      GoRoute(path: '/', builder: (context, state) => HomeScreen()),

      // Authentication-related routes.
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
      GoRoute(path: '/forgot_password', builder: (context, state) => ForgotPasswordScreen()),

      // Full-screen private route: Zone creator/edit screen.
      // This route reads an optional Zone object from state.extra when editing.
      GoRoute(
        path: '/zone-creator',
        builder: (context, state) {
           final zoneToEdit = state.extra as Zone?;
           return ZoneCreatorScreen(zoneToEdit: zoneToEdit);
        }
      ),
      
      // Full-screen private route: Family member creator/edit screen.
      // Reads an optional SubUser from state.extra when editing an existing member.
      GoRoute(
        path: '/family-member-creator',
        builder: (context, state) {
           final memberToEdit = state.extra as SubUser?;
           return FamilyMemberCreatorScreen(memberToEdit: memberToEdit);
        }
      ),

      // ShellRoute provides a persistent shell (e.g. bottom navigation) with child pages.
      ShellRoute(
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
          // These routes are shown inside the main shell without transition animation.
          GoRoute(
            path: '/family',
            pageBuilder: (context, state) => NoTransitionPage(child: FamilyListScreen()),
          ),
          GoRoute(
            path: '/zones',
            pageBuilder: (context, state) => NoTransitionPage(child: ZonesScreen()),
          ),
          GoRoute(
            path: '/menu',
            pageBuilder: (context, state) => NoTransitionPage(child: MenuScreen()),
          ),
        ],
      ),
    ],
    // Redirect logic: controls navigation based on authentication status.
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      // Publicly accessible routes that do not require authentication.
      final publicRoutes = ['/', '/login', '/register', '/forgot_password'];
      final isGoingToPublicRoute = publicRoutes.contains(state.uri.toString());
      // Some private routes should be accessible as full-screen even when not in shell.
      final privateFullScreenRoutes = ['/zone-creator', '/family-member-creator'];
      final isGoingToPrivateFullScreen = privateFullScreenRoutes.any((route) => state.uri.toString().startsWith(route));


      // If user is not authenticated and attempts to access a protected route,
      // redirect them to the login page (unless it's a public or allowed full-screen route).
      if (!isLoggedIn && !isGoingToPublicRoute && !isGoingToPrivateFullScreen) {
        return '/login';
      }

      // If user is authenticated and tries to access a public route, send them to /zones.
      if (isLoggedIn && isGoingToPublicRoute) {
        return '/zones';
      }
      return null; // No redirect; allow navigation to proceed.
    },
  );
}

// Helper: adapts a Stream (AuthBloc) to GoRouter's ChangeNotifier so router can refresh.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    // Immediately notify to initialize router state, then notify on each stream event.
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
