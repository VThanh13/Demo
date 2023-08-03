import 'package:auto_route/auto_route.dart';
import 'package:demo/controller/user_controller.dart';
import 'package:demo/core/bloc/user_bloc/user_bloc.dart';
import 'package:demo/core/bloc/user_bloc/user_event.dart';
import 'package:demo/core/bloc/user_bloc/user_state.dart';
import 'package:demo/router/app_router.gr.dart';
import 'package:demo/screen/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_model.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserBloc userBloc = UserBloc();
  UserController userController = UserController();
  final ScrollController scrollController = ScrollController();

  late User detail;

  void pullToRefresh() {
    userBloc.isLoadMore = true;
    userBloc.page = 1;
    userBloc.users.clear();
    userBloc.add(UserInitialEvent());
  }

  void navigateToDetail() {
    AutoRouter.of(context).push(DetailRoute(detail: detail)).then((value) {
      if (value != null) {
        if (value.runtimeType == String) {
          userBloc.users.removeWhere((element) => element.id == value);
          userBloc.add(ClickToRemoveUserEvent());
        }
        if (value.runtimeType == User) {
          userBloc.users[userBloc.users
                  .indexWhere((element) => element.id == detail.id)] =
              value as User;
          userBloc.add(ClickToEditUserEvent());
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userBloc.add(UserInitialEvent());
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        userBloc.add(ClickToLoadMoreUserEvent());
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),
      body: BlocBuilder(
        bloc: userBloc,
        builder: (context, state) {
          if (state is UserLoadingState) {
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is UserErrorState) {
            return const Text('Error!');
          } else if (state is UserLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                pullToRefresh();
              },
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: userBloc.users.length + 1,
                  itemBuilder: (context, index) {
                    return index < userBloc.users.length
                        ? InkWell(
                            onDoubleTap: () {},
                            onTap: () {
                              detail = userBloc.users[index];
                              navigateToDetail();
                            },
                            child: UserItem(
                              userBloc: userBloc,
                              index: index,
                            ),
                          )
                        : userBloc.isLoadMore == true &&
                                userBloc.moreItems.isNotEmpty
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Center(
                                child: Text('No more items'),
                              );
                  }),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
