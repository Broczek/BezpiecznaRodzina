// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bezpieczna_rodzina/core/di/injection_container.dart' as di;
import 'package:bezpieczna_rodzina/core/navigation/app_router.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bezpieczna_rodzina/main.dart';

void main() {
  // ZMIANA: Inicjalizujemy zależności przed testem
  setUpAll(() {
    di.init();
  });

  testWidgets('Renders HomeScreen and finds Login button', (WidgetTester tester) async {
    // ZMIANA: Przygotowujemy BLoC i router, tak jak w main.dart
    final authBloc = di.sl<AuthBloc>();
    final router = appRouter(authBloc);

    // Build our app and trigger a frame.
    // ZMIANA: Przekazujemy router do widgetu MyApp
    await tester.pumpWidget(
      BlocProvider.value(
        value: authBloc,
        child: MyApp(router: router),
      ),
    );

    // ZMIANA: Zaktualizowany test
    // Weryfikujemy, czy aplikacja uruchamia się na ekranie powitalnym
    // i czy znajduje się na nim przycisk logowania.
    expect(find.text('Zaloguj się'), findsOneWidget);
    expect(find.text('Zarejestruj się'), findsOneWidget);

    // Weryfikujemy, czy nie ma elementów z ekranu po zalogowaniu
    expect(find.byIcon(Icons.security), findsNothing);
  });
}
