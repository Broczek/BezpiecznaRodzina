import 'package:bezpieczna_rodzina/core/di/injection_container.dart' as di;
import 'package:bezpieczna_rodzina/core/navigation/app_router.dart';
import 'package:bezpieczna_rodzina/core/design_system/app_theme.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/bloc/zones_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();

  final authBloc = di.sl<AuthBloc>();
  final familyBloc = di.sl<FamilyBloc>();
  final zonesBloc = di.sl<ZonesBloc>();
  final router = appRouter(authBloc);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: familyBloc),
        BlocProvider.value(value: zonesBloc),
      ],
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatefulWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static void setThemeMode(BuildContext context, ThemeMode newThemeMode) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setThemeMode(newThemeMode);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('pl');
  ThemeMode _themeMode = ThemeMode.system;

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  void setThemeMode(ThemeMode newThemeMode) {
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: ValueKey(_locale),
      title: 'Bezpieczna Rodzina',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: widget.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

