import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qflow/domain/core/failures.dart';
import 'package:qflow/domain/hospital/hospital_model.dart';
import 'package:qflow/domain/hospital/location_model.dart';

part 'hospital_state.freezed.dart';

@freezed
class HospitalState with _$HospitalState {
  const factory HospitalState({
    required bool isLoading,
    required List<HospitalModel> hospitals,
    required List<HospitalModel> searchedHospitals,
    required List<LocationModel> locationSuggestions,
    required Option<HospitalModel> selectedHospital,
    required Option<Either<MainFailure, Unit>> failureOrSuccessOption,
  }) = _HospitalState;

  factory HospitalState.initial() => HospitalState(
        isLoading: false,
        hospitals: [],
        searchedHospitals: [],
        locationSuggestions: [],
        selectedHospital: none(),
        failureOrSuccessOption: none(),
      );
}
