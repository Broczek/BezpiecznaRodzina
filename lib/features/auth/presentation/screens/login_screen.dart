import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// The LoginScreen provides the UI for users to enter their credentials.
// It interacts with the AuthBloc to dispatch login events and reacts to
// authentication state changes, such as showing loading indicators or error messages.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // BlocConsumer is used to both listen for state changes (like showing a SnackBar)
    // and rebuild the UI when specific parts of the state change.
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Show a SnackBar with an error message on authentication failure.
        if (state.status == AuthStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
        }
      },
      // Only rebuild the widget if the status or errorField changes.
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorField != current.errorField,
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => context.go('/')),
            title: Text(l10n.loginTitle),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Custom text field that highlights on error.
                    _buildDecoratedTextField(
                      key: const ValueKey('username_field'), // Key for testing
                      controller: _usernameController,
                      labelText: l10n.loginUsernameLabel,
                      hasError: state.errorField == LoginErrorField.username,
                      validator: (v) =>
                          v!.isEmpty ? l10n.loginRequiredField : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDecoratedTextField(
                      key: const ValueKey('password_field'), // Key for testing
                      controller: _passwordController,
                      labelText: l10n.loginPasswordLabel,
                      hasError: state.errorField == LoginErrorField.password,
                      obscureText: true,
                      validator: (v) =>
                          v!.isEmpty ? l10n.loginRequiredField : null,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot_password'),
                        child: Text(l10n.loginForgotPassword),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      key: const ValueKey('login_submit_button'), // Key for testing
                      onPressed: isLoading ? null : _submitForm,
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 3),
                            )
                          : Text(l10n.loginButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // A helper widget to build a TextFormField with custom error styling.
  Widget _buildDecoratedTextField({
    required TextEditingController controller,
    required String labelText,
    required FormFieldValidator<String> validator,
    Key? key,
    bool hasError = false,
    bool obscureText = false,
  }) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    // The focused border color is overridden if there's an error.
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          focusedBorder: hasError
              ? theme.inputDecorationTheme.focusedBorder?.copyWith(
                  borderSide: BorderSide(color: errorColor, width: 2),
                )
              : null,
        ),
      ),
      child: TextFormField(
        key: key,
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }

  // Validates the form and dispatches the login event.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          );
    }
  }
}

