import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This widget represents the second step of the registration process:
// code verification. The user enters a 6-digit code sent to their
// email or phone to verify their identity.
class RegisterStep2Verify extends StatefulWidget {
  const RegisterStep2Verify({super.key});

  @override
  State<RegisterStep2Verify> createState() => _RegisterStep2VerifyState();
}

class _RegisterStep2VerifyState extends State<RegisterStep2Verify> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with any existing code from the BLoC state.
    final currentState = context.read<RegistrationBloc>().state;
    _codeController =
        TextEditingController(text: currentState.verificationCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Select is used to listen to specific parts of the state for efficiency.
    final state = context.select((RegistrationBloc bloc) => bloc.state);

    return Scaffold(
      appBar: AppBar(
        // The back button dispatches an event to go to the previous step.
        leading: BackButton(
          onPressed: () =>
              context.read<RegistrationBloc>().add(RegistrationStepCancelled()),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.verifyCodeTitle,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                // Display instructions with the user's email or phone.
                Text(
                  l10n.verifyCodeInstruction(state.emailOrPhone),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                // Input field for the 6-digit verification code.
                TextFormField(
                  controller: _codeController,
                  decoration:
                      InputDecoration(labelText: l10n.verifyCodeInputLabel),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 12),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (value) => context
                      .read<RegistrationBloc>()
                      .add(RegistrationCodeChanged(value)),
                  validator: (value) =>
                      (value?.length ?? 0) != 6 ? l10n.verifyCodeInvalid : null,
                ),
                // Display an error message if verification fails.
                if (state.status == RegistrationStatus.failure)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorMessage ?? 'An error occurred',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const Spacer(),
                // Submit button.
                ElevatedButton(
                  onPressed: state.status == RegistrationStatus.loading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<RegistrationBloc>()
                                .add(RegistrationCodeSubmitted());
                          }
                        },
                  child: state.status == RegistrationStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(l10n.verifyButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
