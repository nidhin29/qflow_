// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hospital_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HospitalState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<HospitalModel> get hospitals => throw _privateConstructorUsedError;
  List<HospitalModel> get searchedHospitals =>
      throw _privateConstructorUsedError;
  List<LocationModel> get locationSuggestions =>
      throw _privateConstructorUsedError;
  Option<HospitalModel> get selectedHospital =>
      throw _privateConstructorUsedError;
  Option<Either<MainFailure, Unit>> get failureOrSuccessOption =>
      throw _privateConstructorUsedError;

  /// Create a copy of HospitalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HospitalStateCopyWith<HospitalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HospitalStateCopyWith<$Res> {
  factory $HospitalStateCopyWith(
          HospitalState value, $Res Function(HospitalState) then) =
      _$HospitalStateCopyWithImpl<$Res, HospitalState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<HospitalModel> hospitals,
      List<HospitalModel> searchedHospitals,
      List<LocationModel> locationSuggestions,
      Option<HospitalModel> selectedHospital,
      Option<Either<MainFailure, Unit>> failureOrSuccessOption});
}

/// @nodoc
class _$HospitalStateCopyWithImpl<$Res, $Val extends HospitalState>
    implements $HospitalStateCopyWith<$Res> {
  _$HospitalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HospitalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? hospitals = null,
    Object? searchedHospitals = null,
    Object? locationSuggestions = null,
    Object? selectedHospital = null,
    Object? failureOrSuccessOption = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hospitals: null == hospitals
          ? _value.hospitals
          : hospitals // ignore: cast_nullable_to_non_nullable
              as List<HospitalModel>,
      searchedHospitals: null == searchedHospitals
          ? _value.searchedHospitals
          : searchedHospitals // ignore: cast_nullable_to_non_nullable
              as List<HospitalModel>,
      locationSuggestions: null == locationSuggestions
          ? _value.locationSuggestions
          : locationSuggestions // ignore: cast_nullable_to_non_nullable
              as List<LocationModel>,
      selectedHospital: null == selectedHospital
          ? _value.selectedHospital
          : selectedHospital // ignore: cast_nullable_to_non_nullable
              as Option<HospitalModel>,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<MainFailure, Unit>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HospitalStateImplCopyWith<$Res>
    implements $HospitalStateCopyWith<$Res> {
  factory _$$HospitalStateImplCopyWith(
          _$HospitalStateImpl value, $Res Function(_$HospitalStateImpl) then) =
      __$$HospitalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<HospitalModel> hospitals,
      List<HospitalModel> searchedHospitals,
      List<LocationModel> locationSuggestions,
      Option<HospitalModel> selectedHospital,
      Option<Either<MainFailure, Unit>> failureOrSuccessOption});
}

/// @nodoc
class __$$HospitalStateImplCopyWithImpl<$Res>
    extends _$HospitalStateCopyWithImpl<$Res, _$HospitalStateImpl>
    implements _$$HospitalStateImplCopyWith<$Res> {
  __$$HospitalStateImplCopyWithImpl(
      _$HospitalStateImpl _value, $Res Function(_$HospitalStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HospitalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? hospitals = null,
    Object? searchedHospitals = null,
    Object? locationSuggestions = null,
    Object? selectedHospital = null,
    Object? failureOrSuccessOption = null,
  }) {
    return _then(_$HospitalStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hospitals: null == hospitals
          ? _value._hospitals
          : hospitals // ignore: cast_nullable_to_non_nullable
              as List<HospitalModel>,
      searchedHospitals: null == searchedHospitals
          ? _value._searchedHospitals
          : searchedHospitals // ignore: cast_nullable_to_non_nullable
              as List<HospitalModel>,
      locationSuggestions: null == locationSuggestions
          ? _value._locationSuggestions
          : locationSuggestions // ignore: cast_nullable_to_non_nullable
              as List<LocationModel>,
      selectedHospital: null == selectedHospital
          ? _value.selectedHospital
          : selectedHospital // ignore: cast_nullable_to_non_nullable
              as Option<HospitalModel>,
      failureOrSuccessOption: null == failureOrSuccessOption
          ? _value.failureOrSuccessOption
          : failureOrSuccessOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<MainFailure, Unit>>,
    ));
  }
}

/// @nodoc

class _$HospitalStateImpl implements _HospitalState {
  const _$HospitalStateImpl(
      {required this.isLoading,
      required final List<HospitalModel> hospitals,
      required final List<HospitalModel> searchedHospitals,
      required final List<LocationModel> locationSuggestions,
      required this.selectedHospital,
      required this.failureOrSuccessOption})
      : _hospitals = hospitals,
        _searchedHospitals = searchedHospitals,
        _locationSuggestions = locationSuggestions;

  @override
  final bool isLoading;
  final List<HospitalModel> _hospitals;
  @override
  List<HospitalModel> get hospitals {
    if (_hospitals is EqualUnmodifiableListView) return _hospitals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hospitals);
  }

  final List<HospitalModel> _searchedHospitals;
  @override
  List<HospitalModel> get searchedHospitals {
    if (_searchedHospitals is EqualUnmodifiableListView)
      return _searchedHospitals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchedHospitals);
  }

  final List<LocationModel> _locationSuggestions;
  @override
  List<LocationModel> get locationSuggestions {
    if (_locationSuggestions is EqualUnmodifiableListView)
      return _locationSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locationSuggestions);
  }

  @override
  final Option<HospitalModel> selectedHospital;
  @override
  final Option<Either<MainFailure, Unit>> failureOrSuccessOption;

  @override
  String toString() {
    return 'HospitalState(isLoading: $isLoading, hospitals: $hospitals, searchedHospitals: $searchedHospitals, locationSuggestions: $locationSuggestions, selectedHospital: $selectedHospital, failureOrSuccessOption: $failureOrSuccessOption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HospitalStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._hospitals, _hospitals) &&
            const DeepCollectionEquality()
                .equals(other._searchedHospitals, _searchedHospitals) &&
            const DeepCollectionEquality()
                .equals(other._locationSuggestions, _locationSuggestions) &&
            (identical(other.selectedHospital, selectedHospital) ||
                other.selectedHospital == selectedHospital) &&
            (identical(other.failureOrSuccessOption, failureOrSuccessOption) ||
                other.failureOrSuccessOption == failureOrSuccessOption));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      const DeepCollectionEquality().hash(_hospitals),
      const DeepCollectionEquality().hash(_searchedHospitals),
      const DeepCollectionEquality().hash(_locationSuggestions),
      selectedHospital,
      failureOrSuccessOption);

  /// Create a copy of HospitalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HospitalStateImplCopyWith<_$HospitalStateImpl> get copyWith =>
      __$$HospitalStateImplCopyWithImpl<_$HospitalStateImpl>(this, _$identity);
}

abstract class _HospitalState implements HospitalState {
  const factory _HospitalState(
      {required final bool isLoading,
      required final List<HospitalModel> hospitals,
      required final List<HospitalModel> searchedHospitals,
      required final List<LocationModel> locationSuggestions,
      required final Option<HospitalModel> selectedHospital,
      required final Option<Either<MainFailure, Unit>>
          failureOrSuccessOption}) = _$HospitalStateImpl;

  @override
  bool get isLoading;
  @override
  List<HospitalModel> get hospitals;
  @override
  List<HospitalModel> get searchedHospitals;
  @override
  List<LocationModel> get locationSuggestions;
  @override
  Option<HospitalModel> get selectedHospital;
  @override
  Option<Either<MainFailure, Unit>> get failureOrSuccessOption;

  /// Create a copy of HospitalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HospitalStateImplCopyWith<_$HospitalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
