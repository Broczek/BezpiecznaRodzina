import 'package:bloc_test/bloc_test.dart';
import 'package:bezpieczna_rodzina/core/models/subuser_model.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';

// Mock AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('FamilyBloc', () {
    late AuthRepository mockAuthRepository;
    final mockSubUser = const SubUser(
      id: '1',
      username: 'test_user',
      password: 'password',
      role: SubUserRole.standard,
      deviceName: 'Test Device',
      batteryLevel: 80,
      location: LatLng(52.23, 21.01),
    );

    setUpAll(() {
      // Register a fallback value for any types used with mocktail's `any()`
      registerFallbackValue(mockSubUser);
    });

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    blocTest<FamilyBloc, FamilyState>(
      'emits [FamilyLoading, FamilyLoaded] when FetchFamilyData is added and succeeds',
      setUp: () {
        when(() => mockAuthRepository.getSubUsers()).thenAnswer((_) async => [mockSubUser]);
      },
      build: () => FamilyBloc(authRepository: mockAuthRepository),
      act: (bloc) => bloc.add(FetchFamilyData()),
      expect: () => <FamilyState>[
        FamilyLoading(),
        FamilyLoaded([mockSubUser]),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.getSubUsers()).called(1);
      },
    );

    blocTest<FamilyBloc, FamilyState>(
      'calls addSubUser and re-fetches data when AddFamilyMember is added',
      setUp: () {
        // Mock the addSubUser call
        when(() => mockAuthRepository.addSubUser(any())).thenAnswer((_) async {});
        // Mock the subsequent getSubUsers call
        when(() => mockAuthRepository.getSubUsers()).thenAnswer((_) async => [mockSubUser]);
      },
      build: () => FamilyBloc(authRepository: mockAuthRepository),
      act: (bloc) => bloc.add(AddFamilyMember(mockSubUser)),
      // Expect loading and then the final loaded state from the re-fetch
      expect: () => <FamilyState>[
        FamilyLoading(),
        FamilyLoaded([mockSubUser]),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.addSubUser(mockSubUser)).called(1);
        verify(() => mockAuthRepository.getSubUsers()).called(1);
      },
    );

    blocTest<FamilyBloc, FamilyState>(
      'emits [FamilyLoading, FamilyError] when FetchFamilyData fails',
      setUp: () {
        when(() => mockAuthRepository.getSubUsers()).thenThrow(Exception('Failed to fetch'));
      },
      build: () => FamilyBloc(authRepository: mockAuthRepository),
      act: (bloc) => bloc.add(FetchFamilyData()),
      expect: () => <FamilyState>[
        FamilyLoading(),
        const FamilyError('Exception: Failed to fetch'),
      ],
    );
  });
}
