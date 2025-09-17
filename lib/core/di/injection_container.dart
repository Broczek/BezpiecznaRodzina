import 'package:bezpieczna_rodzina/core/api/mock_api_interceptor.dart';
import 'package:bezpieczna_rodzina/features/auth/data/auth_repository.dart';
import 'package:bezpieczna_rodzina/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bezpieczna_rodzina/features/family/presentation/bloc/family_bloc.dart';
import 'package:bezpieczna_rodzina/features/zones/presentation/bloc/zones_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => AuthBloc(authRepository: sl()));

  sl.registerLazySingleton(() => FamilyBloc(authRepository: sl()));

  sl.registerLazySingleton(() => ZonesBloc(authRepository: sl(), familyBloc: sl()));

  sl.registerLazySingleton(() => AuthRepository());

  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.interceptors.add(MockApiInterceptor());
    return dio;
  });
}

