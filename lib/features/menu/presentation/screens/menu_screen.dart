import 'package:bezpieczna_rodzina/core/models/user_model.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:bezpieczna_rodzina/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This screen serves as the main menu for logged-in users.
// It provides access to account management, app settings (language, theme),
// and a logout option. Access to certain features is restricted based on user role.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Determine user role to conditionally render UI elements.
        final userRole = state.user?.role ?? UserRole.viewer;
        final bool isViewer = userRole == UserRole.viewer;
        final bool isAdmin = userRole == UserRole.admin;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.menuTitle),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // "Account" section is only visible to admins.
              if (isAdmin)
                _SettingsSection(
                  title: l10n.menuSectionAccount,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(l10n.menuManageAccount),
                      subtitle: Text(l10n.menuManageAccountSubtitle),
                      onTap: () {
                        // TODO: Implement account management screen navigation.
                      },
                    ),
                  ],
                ),
              // "Application" section with settings for language and theme.
              _SettingsSection(
                title: l10n.menuSectionApp,
                children: [
                  _LanguageTile(isLocked: isViewer), // Language selection is locked for viewers.
                  _ThemeTile(isLocked: isViewer), // Theme selection is locked for viewers.
                  ListTile(
                    leading: Icon(Icons.logout, color: theme.colorScheme.error),
                    title: Text(l10n.menuLogout,
                        style: TextStyle(color: theme.colorScheme.error)),
                    onTap: () {
                      // Dispatch logout event to AuthBloc.
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// A reusable widget to create a section with a title and a card containing list tiles.
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: children,
          ),
        )
      ],
    );
  }
}

// A ListTile for changing the application language.
class _LanguageTile extends StatelessWidget {
  final bool isLocked;
  const _LanguageTile({this.isLocked = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final langNameMap = {
      'pl': l10n.languagePolish,
      'en': l10n.languageEnglish,
      'de': l10n.languageGerman,
      'es': l10n.languageSpanish,
    };
    final currentLangCode = Localizations.localeOf(context).languageCode;
    final currentLangName = langNameMap[currentLangCode] ?? 'Polish';

    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(l10n.menuLanguage),
      subtitle: Text(currentLangName),
      trailing: isLocked ? const Icon(Icons.lock_outline) : null,
      onTap: isLocked
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _LanguageSelectionSheet(
                  currentLocale: Localizations.localeOf(context),
                  onLanguageSelected: (locale) {
                    MyApp.setLocale(context, locale);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
    );
  }
}

// A ListTile for changing the application theme.
class _ThemeTile extends StatelessWidget {
  final bool isLocked;
  const _ThemeTile({this.isLocked = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Note: A more robust way to get ThemeMode would be from a dedicated ThemeProvider/Bloc.
    // This is a simplified approach for demonstration.
    final themeMode = Theme.of(context).brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
    String themeModeName;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeName = l10n.menuThemeLight;
        break;
      case ThemeMode.dark:
        themeModeName = l10n.menuThemeDark;
        break;
      case ThemeMode.system:
        themeModeName = l10n.menuThemeSystem;
        break;
    }

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(l10n.menuTheme),
      subtitle: Text(themeModeName),
      trailing: isLocked ? const Icon(Icons.lock_outline) : null,
      onTap: isLocked
          ? null
          : () {
              showDialog(
                context: context,
                builder: (context) =>
                    _ThemeSelectionDialog(currentThemeMode: themeMode),
              );
            },
    );
  }
}

// Bottom sheet for language selection.
class _LanguageSelectionSheet extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLanguageSelected;

  const _LanguageSelectionSheet({
    required this.currentLocale,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<MapEntry<String, String>> languages = [
      MapEntry('pl', l10n.languagePolish),
      MapEntry('en', l10n.languageEnglish),
      MapEntry('de', l10n.languageGerman),
      MapEntry('es', l10n.languageSpanish),
    ];

    return SafeArea(
      child: Wrap(
        children: languages.map((lang) {
          final isSelected = lang.key == currentLocale.languageCode;
          return ListTile(
            title: Text(
              lang.value,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check,
                    color: Theme.of(context).colorScheme.primary)
                : null,
            onTap: () => onLanguageSelected(Locale(lang.key)),
          );
        }).toList(),
      ),
    );
  }
}

// Dialog for theme selection.
class _ThemeSelectionDialog extends StatefulWidget {
  final ThemeMode currentThemeMode;
  const _ThemeSelectionDialog({required this.currentThemeMode});

  @override
  State<_ThemeSelectionDialog> createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<_ThemeSelectionDialog> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = widget.currentThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.menuSelectThemeTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ThemeMode>(
            title: Text(l10n.menuThemeLight),
            value: ThemeMode.light,
            groupValue: _selectedThemeMode,
            onChanged: (value) => setState(() => _selectedThemeMode = value!),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.menuThemeDark),
            value: ThemeMode.dark,
            groupValue: _selectedThemeMode,
            onChanged: (value) => setState(() => _selectedThemeMode = value!),
          ),
          RadioListTile<ThemeMode>(
            title: Text(l10n.menuThemeSystem),
            value: ThemeMode.system,
            groupValue: _selectedThemeMode,
            onChanged: (value) => setState(() => _selectedThemeMode = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.searchCancelButton),
        ),
        TextButton(
          onPressed: () {
            MyApp.setThemeMode(context, _selectedThemeMode);
            Navigator.of(context).pop();
          },
          child: Text(l10n.menuSaveButton),
        )
      ],
    );
  }
}
