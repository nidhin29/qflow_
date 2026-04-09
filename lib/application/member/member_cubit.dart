import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/member/member_model.dart';
import 'package:qflow/domain/member/member_service.dart';
import 'member_state.dart';

@injectable
class MemberCubit extends Cubit<MemberState> {
  final IMemberService _memberService;

  MemberCubit(this._memberService) : super(MemberState.initial()) {
    getMembers();
  }

  Future<void> getMembers() async {
    emit(state.copyWith(isLoading: true));
    final result = await _memberService.getMembers();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (members) => emit(state.copyWith(isLoading: false, members: members)),
    );
  }

  Future<void> addMember({required MemberModel member}) async {
    // Optimistic Update: Add to list immediately
    final oldMembers = List<MemberModel>.from(state.members);
    final optimisticMember = member.id == null 
        ? member.copyWith(id: "temp_${DateTime.now().millisecondsSinceEpoch}")
        : member;
    
    final newMembers = List<MemberModel>.from(state.members)..add(optimisticMember);
    emit(state.copyWith(members: newMembers, failureOrSuccessOption: none()));

    final result = await _memberService.addMember(member: member);
    result.fold(
      (failure) {
        // Rollback on failure
        emit(state.copyWith(
          members: oldMembers,
          failureOrSuccessOption: some(left(failure)),
        ));
      },
      (unit) {
        // Refresh to get the real ID from backend
        getMembers();
      },
    );
  }

  Future<void> updateMember({required MemberModel member}) async {
    // Optimistic Update: Update in list immediately
    final oldMembers = List<MemberModel>.from(state.members);
    final newMembers = state.members.map((m) => m.id == member.id ? member : m).toList();
    emit(state.copyWith(members: newMembers, failureOrSuccessOption: none()));

    final result = await _memberService.updateMember(member: member);
    result.fold(
      (failure) {
        // Rollback on failure
        emit(state.copyWith(
          members: oldMembers,
          failureOrSuccessOption: some(left(failure)),
        ));
      },
      (unit) {
        // Refresh to ensure everything is in sync
        getMembers();
      },
    );
  }

  Future<void> deleteMember(String id) async {
    // Optimistic Update: Remove from list immediately
    final oldMembers = List<MemberModel>.from(state.members);
    final newMembers = state.members.where((m) => m.id != id).toList();
    emit(state.copyWith(members: newMembers, failureOrSuccessOption: none()));

    final result = await _memberService.deleteMember(id);
    result.fold(
      (failure) {
        // Rollback on failure
        emit(state.copyWith(
          members: oldMembers,
          failureOrSuccessOption: some(left(failure)),
        ));
      },
      (unit) {
        getMembers();
      },
    );
  }
}
