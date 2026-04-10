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
import 'package:qflow/application/appointment/appointment_cubit.dart' as _i397;
import 'package:qflow/application/auth/otp/otp_cubit.dart' as _i226;
import 'package:qflow/application/auth/register_details/register_details_cubit.dart'
    as _i1028;
import 'package:qflow/application/auth/sign_in/sign_in_cubit.dart' as _i466;
import 'package:qflow/application/auth/sign_up/sign_up_cubit.dart' as _i871;
import 'package:qflow/application/hospital/hospital_cubit.dart' as _i133;
import 'package:qflow/application/member/member_cubit.dart' as _i709;
import 'package:qflow/application/notification/notification_cubit.dart'
    as _i165;
import 'package:qflow/application/profile/profile_cubit.dart' as _i1045;
import 'package:qflow/domain/appointment/appointment_service.dart' as _i280;
import 'package:qflow/domain/auth/app_session.dart' as _i218;
import 'package:qflow/domain/auth/auth_service.dart' as _i116;
import 'package:qflow/domain/hospital/i_hospital_service.dart' as _i806;
import 'package:qflow/domain/member/member_service.dart' as _i891;
import 'package:qflow/domain/notification/notification_service.dart' as _i127;
import 'package:qflow/domain/user/user_service.dart' as _i418;
import 'package:qflow/infrastructure/appointment/appointment_repository.dart'
    as _i800;
import 'package:qflow/infrastructure/auth/auth_repository.dart' as _i736;
import 'package:qflow/infrastructure/core/network_module.dart' as _i844;
import 'package:qflow/infrastructure/core/socket_service.dart' as _i585;
import 'package:qflow/infrastructure/hospital/hospital_repository.dart'
    as _i842;
import 'package:qflow/infrastructure/member/member_repository.dart' as _i700;
import 'package:qflow/infrastructure/notification/notification_repository.dart'
    as _i611;
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
    gh.lazySingleton<_i218.AppSession>(
        () => _i218.AppSession(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i585.SocketService>(
      () => _i585.SocketService(gh<_i218.AppSession>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i361.Dio>(
        () => networkModule.dio(gh<_i218.AppSession>()));
    gh.lazySingleton<_i806.IHospitalService>(
        () => _i842.HospitalRepository(gh<_i361.Dio>()));
    gh.factory<_i133.HospitalCubit>(
        () => _i133.HospitalCubit(gh<_i806.IHospitalService>()));
    gh.lazySingleton<_i891.IMemberService>(
        () => _i700.MemberRepository(gh<_i361.Dio>()));
    gh.factory<_i709.MemberCubit>(
        () => _i709.MemberCubit(gh<_i891.IMemberService>()));
    gh.lazySingleton<_i116.IAuthService>(() => _i736.AuthRepository(
          gh<_i361.Dio>(),
          gh<_i558.FlutterSecureStorage>(),
          gh<_i218.AppSession>(),
        ));
    gh.lazySingleton<_i127.INotificationService>(
        () => _i611.NotificationRepository(gh<_i361.Dio>()));
    gh.lazySingleton<_i280.IAppointmentService>(
        () => _i800.AppointmentRepository(gh<_i361.Dio>()));
    gh.lazySingleton<_i418.IUserService>(() => _i295.UserRepository(
          gh<_i361.Dio>(),
          gh<_i218.AppSession>(),
        ));
    gh.factory<_i397.AppointmentCubit>(() => _i397.AppointmentCubit(
          gh<_i280.IAppointmentService>(),
          gh<_i585.SocketService>(),
        ));
    gh.factory<_i165.NotificationCubit>(
        () => _i165.NotificationCubit(gh<_i127.INotificationService>()));
    gh.factory<_i1045.ProfileCubit>(() => _i1045.ProfileCubit(
          gh<_i418.IUserService>(),
          gh<_i218.AppSession>(),
        ));
    gh.factory<_i1028.RegisterDetailsCubit>(
        () => _i1028.RegisterDetailsCubit(gh<_i418.IUserService>()));
    gh.factory<_i226.OTPCubit>(() => _i226.OTPCubit(gh<_i116.IAuthService>()));
    gh.factory<_i466.SignInCubit>(
        () => _i466.SignInCubit(gh<_i116.IAuthService>()));
    gh.factory<_i871.SignUpCubit>(
        () => _i871.SignUpCubit(gh<_i116.IAuthService>()));
    return this;
  }
}

class _$NetworkModule extends _i844.NetworkModule {}
