import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

@immutable
abstract class UserState {}

abstract class UserActionState extends UserState {}

class UserInnitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final List<User> users;
  UserLoadedState({
    required this.users,
  });
}

class UserErrorState extends UserState {}

class UserLoadMoreError extends UserState {}

class UserLoadingMore extends UserState {}

class UserStopLoadMore extends UserState {}

class ClickToEditUserState extends UserState {}

class ClickToRemoveUserState extends UserState {}
