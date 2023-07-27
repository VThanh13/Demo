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
    on<ClickToLoadMoreUserEvent>(clickToLoadMoreUserEvent);
  }

  List<User> users = [];
  List<User> moreItems = [];
  int page = 1;

  UserController userController = UserController();

  FutureOr<void> userInitialEvent(
      UserInitialEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      await userController.getUserInfo();
      users = userController.user;
      moreItems = userController.moreItems;
      emit(UserLoadedState(users: users));
    } catch (e) {
      emit(UserErrorState());
    }
  }

  FutureOr<void> clickToEditUserEvent(
      ClickToEditUserEvent event, Emitter<UserState> emit) {
    emit(UserLoadedState(users: users));
  }

  FutureOr<void> clickToRemoveUserEvent(
      ClickToRemoveUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoadedState(users: users));
  }

  FutureOr<void> clickToLoadMoreUserEvent(
      ClickToLoadMoreUserEvent event, Emitter<UserState> emit) async {
    try {
      if (userController.isLoadMore == true) {
        page++;
        await userController.loadMoreUser(page);
      }
      moreItems = userController.moreItems;
      users.addAll(moreItems);
      emit(UserLoadedState(users: userController.user));
    } catch (e) {
      emit(UserErrorState());
    }
  }
}
