import 'package:bezpieczna_rodzina/core/di/injection_container.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/widgets/register_step1_form.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/widgets/register_step2_verify.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/widgets/register_step3_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This screen acts as the main container for the multi-step registration flow.
// It uses a BlocProvider to create and provide the RegistrationBloc to its children.
// An AnimatedSwitcher is used to smoothly transition between the different steps
// of the registration process based on the state of the RegistrationBloc.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create an instance of RegistrationBloc for the registration subtree.
      create: (context) => RegistrationBloc(
        authRepository: sl<AuthRepository>(),
        authBloc: context.read<AuthBloc>(), // Provide AuthBloc for post-registration login.
      ),
      child: Scaffold(
        body: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            // AnimatedSwitcher provides a smooth cross-fade transition between steps.
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentStep(context, state.currentStep),
            );
          },
        ),
      ),
    );
  }

  // Helper function to return the correct widget for the current registration step.
  Widget _buildCurrentStep(BuildContext context, int step) {
    switch (step) {
      case 0:
        return const RegisterStep1Form();
      case 1:
        return const RegisterStep2Verify();
      case 2:
        return const RegisterStep3Setup();
      default:
        return const RegisterStep1Form(); // Fallback to the first step.
    }
  }
}
