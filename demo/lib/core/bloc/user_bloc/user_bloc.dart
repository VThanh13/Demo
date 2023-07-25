import 'dart:async';

import 'package:demo/controller/user_controller.dart';
import 'package:demo/core/bloc/user_bloc/user_event.dart';
import 'package:demo/core/bloc/user_bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInnitialState()) {
    on<UserInitialEvent>(userInitialEvent);
    on<ClickToEditUserEvent>(clickToEditUserEvent);
    on<ClickToRemoveUserEvent>(clickToRemoveUserEvent);
  }

  List<User> users = [];
  List<User> moreItems = [];
  FutureOr<void> userInitialEvent(
      UserInitialEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    UserController userController = UserController();
    try {
      await userController.getUserInfo();
      users = userController.user;
      moreItems = userController.moreItems;
      emit(UserLoadedState(users: userController.user));
    } catch (e) {
      emit(UserErrorState());
    }
  }

  FutureOr<void> clickToEditUserEvent(
      ClickToEditUserEvent event, Emitter<UserState> emit) {
    emit(ClickToEditUserState());
  }

  FutureOr<void> clickToRemoveUserEvent(
      ClickToRemoveUserEvent event, Emitter<UserState> emit) {
    emit(ClickToRemoveUserState());
  }
}
