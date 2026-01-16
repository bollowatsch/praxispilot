import 'package:PraxisPilot/core/providers/supabase_provider.dart';
import 'package:PraxisPilot/features/onboarding/data/datasources/personal_info_remote_datasource.dart';
import 'package:PraxisPilot/features/onboarding/data/datasources/practice_info_remote_datasource.dart';
import 'package:PraxisPilot/features/onboarding/data/repositories/personal_info_repository_impl.dart';
import 'package:PraxisPilot/features/onboarding/data/repositories/practice_info_repository_impl.dart';
import 'package:PraxisPilot/features/onboarding/domain/repositories/personal_info_repository.dart';
import 'package:PraxisPilot/features/onboarding/domain/repositories/practice_info_repository.dart';
import 'package:PraxisPilot/features/onboarding/domain/usecases/set_personal_info.dart';
import 'package:PraxisPilot/features/onboarding/domain/usecases/set_practice_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_providers.g.dart';

// Personal Info Providers
@riverpod
PersonalInfoRemoteDataSourceImpl personalInfoRemoteDataSource(Ref ref) =>
    PersonalInfoRemoteDataSourceImpl(
      supabaseClient: ref.read(supabaseClientProvider),
    );

@riverpod
PersonalInfoRepository personalInfoRepository(Ref ref) =>
    PersonalInfoRepositoryImpl(
      remoteDataSource: ref.read(personalInfoRemoteDataSourceProvider),
    );

@riverpod
SetPersonalInfo setPersonalInfo(Ref ref) => SetPersonalInfo(
  repository: ref.watch(personalInfoRepositoryProvider),
);

// Practice Info Providers
@riverpod
PracticeInfoRemoteDataSourceImpl practiceInfoRemoteDataSource(Ref ref) =>
    PracticeInfoRemoteDataSourceImpl(
      supabaseClient: ref.read(supabaseClientProvider),
    );

@riverpod
PracticeInfoRepository practiceInfoRepository(Ref ref) =>
    PracticeInfoRepositoryImpl(
      remoteDataSource: ref.read(practiceInfoRemoteDataSourceProvider),
    );

@riverpod
SetPracticeInfo setPracticeInfo(Ref ref) => SetPracticeInfo(
  repository: ref.watch(practiceInfoRepositoryProvider),
);