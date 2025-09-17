import 'package:bezpieczna_rodzina/main.dart';
import 'package:flutter/material.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

// This is the initial screen of the application, serving as a welcome or landing page.
// It is publicly accessible and provides options to log in, register,
// change the language, and toggle the theme.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Theme toggle button at the top right.
              const Align(
                alignment: Alignment.topRight,
                child: _ThemeToggleButton(),
              ),
              const Spacer(flex: 2),
              // App title and icon.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 48,
                    color: colors.secondary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.homeWelcomeTitle,
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface, 
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 3),
              // Login and Register buttons.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: Text(l10n.loginButton),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/register'),
                  child: Text(l10n.registerButton),
                ),
              ),
              const Spacer(flex: 1),
              // Language selection button.
              const _LanguageSelectorButton(),
            ],
          ),
        ),
      ),
    );
  }
}

// A button to toggle between light and dark themes.
class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      onPressed: () {
        final newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
        // Call the static method on MyApp to update the theme.
        MyApp.setThemeMode(context, newThemeMode);
      },
      icon: Icon(
        isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      tooltip: isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
    );
  }
}

// A simple class to hold language data.
class Language {
  final String code;
  final String name;

  Language(this.code, this.name);
}

// A button that opens a bottom sheet to select the application language.
class _LanguageSelectorButton extends StatelessWidget {
  const _LanguageSelectorButton();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languages = [
      Language('pl', l10n.languagePolish),
      Language('en', l10n.languageEnglish),
      Language('de', l10n.languageGerman),
      Language('es', l10n.languageSpanish),
    ];

    final currentLocale = Localizations.localeOf(context);
    final currentLangName = languages
        .firstWhere((lang) => lang.code == currentLocale.languageCode,
            orElse: () => Language('pl', l10n.languagePolish))
        .name;

    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _LanguageSelectionSheet(
            languages: languages,
            currentLocale: currentLocale,
            onLanguageSelected: (locale) {
              // Call the static method on MyApp to update the locale.
              MyApp.setLocale(context, locale);
              Navigator.of(context).pop();
            },
          ),
        );
      },
      icon: const Icon(Icons.language),
      label: Text(currentLangName),
    );
  }
}

// The bottom sheet widget that lists available languages.
class _LanguageSelectionSheet extends StatelessWidget {
  final List<Language> languages;
  final Locale currentLocale;
  final ValueChanged<Locale> onLanguageSelected;

  const _LanguageSelectionSheet({
    required this.languages,
    required this.currentLocale,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: languages.map((lang) {
          final isSelected = lang.code == currentLocale.languageCode;
          return ListTile(
            title: Text(
              lang.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
            trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
            onTap: () => onLanguageSelected(Locale(lang.code)),
          );
        }).toList(),
      ),
    );
  }
}
