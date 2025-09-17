import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:bezpieczna_rodzina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// This widget represents the first step of the registration process.
// It collects the user's initial details, such as email/phone, username,
// and password, and validates the input before proceeding.
class RegisterStep1Form extends StatefulWidget {
  const RegisterStep1Form({super.key});

  @override
  State<RegisterStep1Form> createState() => _RegisterStep1FormState();
}

class _RegisterStep1FormState extends State<RegisterStep1Form> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailOrPhoneController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing state data if the user navigates back.
    final currentState = context.read<RegistrationBloc>().state;
    _emailOrPhoneController =
        TextEditingController(text: currentState.emailOrPhone);
    _usernameController = TextEditingController(text: currentState.username);
    _passwordController = TextEditingController(text: currentState.password);
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<RegistrationBloc, RegistrationState>(
      // Clear the email/phone field if the registration type changes.
      listener: (context, state) {
        if (state.registrationType !=
            context.read<RegistrationBloc>().state.registrationType) {
          _emailOrPhoneController.clear();
        }
      },
      child: Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.go('/'))),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.registerTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  // Toggle button for Email/Phone selection.
                  const _RegistrationTypeToggle(),
                  const SizedBox(height: 24),
                  // Email or Phone input field, which rebuilds on type change.
                  BlocBuilder<RegistrationBloc, RegistrationState>(
                    buildWhen: (previous, current) =>
                        previous.registrationType != current.registrationType,
                    builder: (context, state) {
                      return TextFormField(
                        controller: _emailOrPhoneController,
                        decoration: InputDecoration(
                          labelText:
                              state.registrationType == RegistrationType.email
                                  ? l10n.registerEmailLabel
                                  : l10n.registerPhoneLabel,
                        ),
                        keyboardType:
                            state.registrationType == RegistrationType.email
                                ? TextInputType.emailAddress
                                : TextInputType.phone,
                        onChanged: (value) => context
                            .read<RegistrationBloc>()
                            .add(RegistrationEmailOrPhoneChanged(value)),
                        validator: (value) => (value?.isEmpty ?? true)
                            ? l10n.loginRequiredField
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Username field.
                  TextFormField(
                    controller: _usernameController,
                    decoration:
                        InputDecoration(labelText: l10n.registerUsernameLabel),
                    onChanged: (value) => context
                        .read<RegistrationBloc>()
                        .add(RegistrationUsernameChanged(value)),
                    validator: (value) => (value?.isEmpty ?? true)
                        ? l10n.loginRequiredField
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Password field.
                  TextFormField(
                    controller: _passwordController,
                    decoration:
                        InputDecoration(labelText: l10n.registerPasswordLabel),
                    obscureText: true,
                    onChanged: (value) => context
                        .read<RegistrationBloc>()
                        .add(RegistrationPasswordChanged(value)),
                    validator: (value) => (value?.length ?? 0) < 6
                        ? l10n.registerPasswordMinLength
                        : null,
                  ),
                  const Spacer(),
                  // Submit button.
                  BlocBuilder<RegistrationBloc, RegistrationState>(
                    buildWhen: (p, c) => p.status != c.status,
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.status == RegistrationStatus.loading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<RegistrationBloc>()
                                      .add(RegistrationCredentialsSubmitted());
                                }
                              },
                        child: state.status == RegistrationStatus.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(l10n.registerContinueButton),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// A widget for the Email/Phone toggle buttons.
class _RegistrationTypeToggle extends StatelessWidget {
  const _RegistrationTypeToggle();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final type =
        context.select((RegistrationBloc bloc) => bloc.state.registrationType);

    return ToggleButtons(
      isSelected: [
        type == RegistrationType.email,
        type == RegistrationType.phone
      ],
      onPressed: (index) {
        final newType =
            index == 0 ? RegistrationType.email : RegistrationType.phone;
        context.read<RegistrationBloc>().add(RegistrationTypeChanged(newType));
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
            child: Text(l10n.registerEmailToggle)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.registerPhoneToggle)),
      ],
    );
  }
}
