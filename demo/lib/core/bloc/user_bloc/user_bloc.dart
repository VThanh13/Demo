import 'dart:async';

import 'package:demo/controller/user_controller.dart';
import 'package:demo/core/bloc/user_bloc/user_event.dart';
import 'package:demo/core/bloc/user_bloc/user_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import '../../service/dio_utils.dart';
import '../../service/user_services.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInnitialState()) {
    on<UserInitialEvent>(userInitialEvent);
    on<ClickToEditUserEvent>(clickToEditUserEvent);
    on<ClickToRemoveUserEvent>(clickToRemoveUserEvent);
    on<ClickToLoadMoreUserEvent>(clickToLoadMoreUserEvent);
    on<ClickToReloadEvent>(clickToReloadEvent);
  }

  List<User> users = [];
  List<User> moreItems = [];
  int page = 1;

  final baseUrl = 'https://64bdcfeb2320b36433c7d728.mockapi.io/users';

  bool isLoadMore = true;

  bool? isLoadingMore;

  UserController userController = UserController();

  Completer? completer;

  FutureOr<void> userInitialEvent(
      UserInitialEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());
    try {
      final response = await UserService().getUser('$baseUrl?page=1&limit=10');
      if (response.statusCode == 200) {
        users.clear();
        users.addAll((response.data ?? []).map((e) => User.fromJson(e)));
        moreItems.add(
          User(name: "", avatar: "", address: "", id: ""),
        );
        emit(UserLoadedState(users: users));
      } else {
        emit(UserErrorState());
        throw Exception('API failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ErrorHandle.handleError(e);
      emit(UserErrorState());
    } catch (e) {
      emit(UserErrorState());
      throw Exception('API call failed with exception: $e');
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
    if (isLoadMore == true) {
      page++;
      try {
        final response =
            await UserService().getUser('$baseUrl?page=$page&limit=6');
        if (response.statusCode == 200) {
          if (response.data!.isNotEmpty) {
            moreItems.clear();
            moreItems
                .addAll((response.data ?? []).map((e) => User.fromJson(e)));
            users.addAll(moreItems);
            emit(UserLoadedState(users: users));
          } else {
            isLoadMore = false;
            moreItems.clear();
            emit(UserLoadedState(users: users));
          }
        } else {
          throw Exception(
              'API failed with status code: ${response.statusCode}');
        }
      } on DioException catch (e) {
        ErrorHandle.handleError(e);
      } catch (e) {
        throw Exception('API call failed with exception: $e');
      }
    }
  }

  FutureOr<void> clickToReloadEvent(
      ClickToReloadEvent event, Emitter<UserState> emit) async {
    try {
      final response = await UserService().getUser('$baseUrl?page=1&limit=10');
      if (response.statusCode == 200) {
        users.clear();
        users.addAll((response.data ?? []).map((e) => User.fromJson(e)));
        moreItems.add(
          User(name: "", avatar: "", address: "", id: ""),
        );
        emit(UserLoadedState(users: users));
      } else {
        emit(UserErrorState());
        throw Exception('API failed with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ErrorHandle.handleError(e);
      emit(UserErrorState());
    } catch (e) {
      emit(UserErrorState());
      throw Exception('API call failed with exception: $e');
    } finally {
      completer?.complete();
    }
  }
}
