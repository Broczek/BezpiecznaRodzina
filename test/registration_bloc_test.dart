import 'package:bloc_test/bloc_test.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockAuthRepository extends Mock implements AuthRepository {}
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  group('RegistrationBloc', () {
    late AuthRepository authRepository;
    late AuthBloc authBloc;

    setUp(() {
      authRepository = MockAuthRepository();
      authBloc = MockAuthBloc();
    });

    test('initial state is correct', () {
      expect(
        RegistrationBloc(authRepository: authRepository, authBloc: authBloc).state,
        const RegistrationState(),
      );
    });

    group('RegistrationCredentialsSubmitted', () {
      blocTest<RegistrationBloc, RegistrationState>(
        'emits [loading, initial with step 1] when credentials are submitted',
        build: () => RegistrationBloc(authRepository: authRepository, authBloc: authBloc),
        act: (bloc) => bloc.add(RegistrationCredentialsSubmitted()),
        // 'wait' is no longer needed as artificial delays are removed from the BLoC
        expect: () => <RegistrationState>[
          const RegistrationState(status: RegistrationStatus.loading),
          const RegistrationState(status: RegistrationStatus.initial, currentStep: 1),
        ],
      );
    });
    
    group('RegistrationCodeSubmitted', () {
      blocTest<RegistrationBloc, RegistrationState>(
        'emits [loading, initial with step 2] when code is correct',
        build: () => RegistrationBloc(authRepository: authRepository, authBloc: authBloc),
        seed: () => const RegistrationState(verificationCode: '123456'),
        act: (bloc) => bloc.add(RegistrationCodeSubmitted()),
        expect: () => <RegistrationState>[
          const RegistrationState(status: RegistrationStatus.loading, verificationCode: '123456'),
          const RegistrationState(status: RegistrationStatus.initial, currentStep: 2, verificationCode: '123456'),
        ],
      );

      blocTest<RegistrationBloc, RegistrationState>(
        'emits [loading, failure] when code is incorrect',
        build: () => RegistrationBloc(authRepository: authRepository, authBloc: authBloc),
        seed: () => const RegistrationState(verificationCode: '000000'),
        act: (bloc) => bloc.add(RegistrationCodeSubmitted()),
        expect: () => <RegistrationState>[
          const RegistrationState(status: RegistrationStatus.loading, verificationCode: '000000'),
          const RegistrationState(
              status: RegistrationStatus.failure,
              errorMessage: 'Invalid code',
              verificationCode: '000000'),
        ],
      );
    });
  });
}

