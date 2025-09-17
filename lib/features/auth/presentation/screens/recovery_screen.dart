import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:bezpieczna_rodzina/core/di/injection_container.dart';

// This screen provides a UI for users to recover their account,
// either by requesting a password reset or a username reminder.
// It interacts directly with the AuthRepository to initiate the recovery process.

enum RecoveryType { password, login }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  RecoveryType _recoveryType = RecoveryType.password;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final AuthRepository _authRepository = sl<AuthRepository>();

  // Sends the recovery request to the repository.
  Future<void> _sendRecoveryRequest() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Call the repository to handle the account recovery logic.
      await _authRepository.recoverAccount(_emailController.text);

      final recoveryItem = _recoveryType == RecoveryType.login
          ? l10n.recoveryItemLogin
          : l10n.recoveryItemPassword;
      if (mounted) {
        // Show a success message to the user.
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                  l10n.recoverySuccessMessage(_emailController.text, recoveryItem)),
              backgroundColor: Colors.green,
            ),
          );
      }
    } catch (e) {
      if (mounted) {
        // Show an error message if recovery fails.
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recoveryTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.recoveryQuestion,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                // Toggle between password and login recovery.
                _RecoveryTypeToggle(
                  selectedType: _recoveryType,
                  onTypeChanged: (newType) =>
                      setState(() => _recoveryType = newType),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.recoveryEmailLabel),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.loginRequiredField;
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return l10n.recoveryInvalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendRecoveryRequest,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3),
                        )
                      : Text(l10n.recoverySendButton),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// A custom widget for the toggle buttons (Password/Login).
class _RecoveryTypeToggle extends StatelessWidget {
  final RecoveryType selectedType;
  final ValueChanged<RecoveryType> onTypeChanged;

  const _RecoveryTypeToggle(
      {required this.selectedType, required this.onTypeChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ToggleButtons(
      isSelected: [
        selectedType == RecoveryType.password,
        selectedType == RecoveryType.login
      ],
      onPressed: (index) {
        onTypeChanged(index == 0 ? RecoveryType.password : RecoveryType.login);
      },
      borderRadius: BorderRadius.circular(12.0),
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      selectedColor: Theme.of(context).colorScheme.primary,
      constraints: BoxConstraints(
          minWidth: (MediaQuery.of(context).size.width - 52) / 2,
          minHeight: 48),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.recoveryItemPassword.toUpperCase()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.recoveryItemLogin.toUpperCase()),
        ),
      ],
    );
  }
}
