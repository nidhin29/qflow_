import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/application/hospital/hospital_state.dart';
import 'package:qflow/domain/hospital/i_hospital_service.dart';

@injectable
class HospitalCubit extends Cubit<HospitalState> {
  final IHospitalService _hospitalService;

  HospitalCubit(this._hospitalService) : super(HospitalState.initial());

  Future<void> getHospitalsByLocation({
    required String location,
    int page = 1,
    int limit = 10,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      failureOrSuccessOption: none(),
    ));

    final result = await _hospitalService.getHospitalsByLocation(
      location: location,
      page: page,
      limit: limit,
    );

    emit(result.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      ),
      (hospitals) => state.copyWith(
        isLoading: false,
        hospitals: hospitals,
        failureOrSuccessOption: some(right(unit)),
      ),
    ));
  }

  Future<void> getHospitalById({required String hospitalId}) async {
    emit(state.copyWith(
      isLoading: true,
      failureOrSuccessOption: none(),
    ));

    final result = await _hospitalService.getHospitalById(hospitalId: hospitalId);

    emit(result.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      ),
      (hospital) => state.copyWith(
        isLoading: false,
        selectedHospital: some(hospital),
        failureOrSuccessOption: some(right(unit)),
      ),
    ));
  }

  Future<void> searchLocations({required String query}) async {
    if (query.isEmpty) {
      emit(state.copyWith(locationSuggestions: []));
      return;
    }

    // We don't set isLoading here to avoid flickering the main UI
    // The search UI will handle its own loading state if needed
    final result = await _hospitalService.searchLocations(query: query);

    emit(result.fold(
      (f) => state.copyWith(locationSuggestions: []),
      (locations) => state.copyWith(locationSuggestions: locations),
    ));
  }

  Future<void> searchHospitals({
    required String query,
    String? filter,
    int page = 1,
    int limit = 10,
  }) async {
    if (query.isEmpty) {
      emit(state.copyWith(searchedHospitals: []));
      return;
    }

    emit(state.copyWith(isLoading: true, failureOrSuccessOption: none()));

    final result = await _hospitalService.searchHospitals(
      query: query,
      filter: filter,
      page: page,
      limit: limit,
    );

    emit(result.fold(
      (f) => state.copyWith(
        isLoading: false,
        failureOrSuccessOption: some(left(f)),
      ),
      (hospitals) => state.copyWith(
        isLoading: false,
        searchedHospitals: hospitals,
        failureOrSuccessOption: some(right(unit)),
      ),
    ));
  }

  void clear() {
    emit(HospitalState.initial());
  }
}
