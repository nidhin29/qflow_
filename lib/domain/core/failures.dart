import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class MainFailure with _$MainFailure {
  const factory MainFailure.clientFailure() = _ClientFailure;
  const factory MainFailure.authFailure() = _AuthFailure;
  const factory MainFailure.serverFailure() = _ServerFailure;
  const factory MainFailure.serverError({int? code, String? message}) =
      _ServerError;
}
