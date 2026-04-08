// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:qflow/application/auth/sign_in/sign_in_cubit.dart' as _i466;
import 'package:qflow/application/profile/profile_cubit.dart' as _i1045;
import 'package:qflow/domain/auth/auth_service.dart' as _i116;
import 'package:qflow/domain/user/user_service.dart' as _i418;
import 'package:qflow/infrastructure/auth/auth_repository.dart' as _i736;
import 'package:qflow/infrastructure/core/network_module.dart' as _i844;
import 'package:qflow/infrastructure/user/user_repository.dart' as _i295;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => networkModule.secureStorage);
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.factory<_i466.SignInCubit>(
        () => _i466.SignInCubit(gh<_i116.IAuthService>()));
    gh.lazySingleton<_i418.IUserService>(
        () => _i295.UserRepository(gh<_i361.Dio>()));
    gh.lazySingleton<_i116.IAuthService>(
        () => _i736.AuthRepository(gh<_i361.Dio>()));
    gh.factory<_i1045.ProfileCubit>(
        () => _i1045.ProfileCubit(gh<_i418.IUserService>()));
    return this;
  }
}

class _$NetworkModule extends _i844.NetworkModule {}
