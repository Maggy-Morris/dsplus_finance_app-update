import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../core/app/app_export.dart';
import 'package:dsplus_finance/presentation/profile_screen/models/profile_model.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(ProfileState initialState) : super(initialState) {
    on<ProfileInitialEvent>(_onInitialize);
  }

  _onInitialize(
    ProfileInitialEvent event,
    Emitter<ProfileState> emit,
  ) async {}
}
