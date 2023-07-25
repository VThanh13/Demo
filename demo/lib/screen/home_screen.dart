import 'package:auto_route/auto_route.dart';
import 'package:demo/controller/user_controller.dart';
import 'package:demo/core/bloc/user_bloc/user_bloc.dart';
import 'package:demo/core/bloc/user_bloc/user_event.dart';
import 'package:demo/core/bloc/user_bloc/user_state.dart';
import 'package:demo/router/app_router.gr.dart';
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

  @override
  void initState() {
    super.initState();
    userBloc.add(UserInitialEvent());
    userController.getUserInfo();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (userController.isLoadMore == true) {
          page++;
          await userController.loadMoreUser(page);
          setState(() {
            userController.user;
            userBloc.users = userController.user;
          });
        }
      }
    });
  }

  UserController userController = UserController();
  final ScrollController scrollController = ScrollController();
  int page = 1;

  User detail = User(name: '', avatar: '', address: '', id: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),
      body: BlocConsumer(
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
                  setState(() {
                    page = 1;
                    userController.isLoadMore = true;
                  });
                  userBloc.users.clear();
                  userBloc.add(UserInitialEvent());
                  await userController.getUserInfo();
                  userController.user;
                  userBloc.users;
                },
                color: Colors.white,
                backgroundColor: Colors.blue,
                displacement: 20,
                child: SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: userBloc.users.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          key: ObjectKey(userBloc.users[index]),
                          onTap: () {
                            setState(() {
                              detail = userBloc.users[index];
                            });
                            //Navigate by context
                            // context.pushRoute(DetailRoute(detail: detail)).then(
                            //     (value) => userBloc.add(UserInitialEvent()));
                            //Naviagte by AutoRoute
                            AutoRouter.of(context)
                                .push(DetailRoute(detail: detail))
                                .then(
                                  (_) => userBloc.add(
                                    UserInitialEvent(),
                                  ),
                                );
                          },
                          child: Container(
                            height: 100,
                            width: double.maxFinite,
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                            color: index % 2 == 0
                                ? const Color(0xffFAFAFA)
                                : const Color(0xffE5E5E5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  child: Image(
                                    image: NetworkImage(
                                        userBloc.users[index].avatar),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userBloc.users[index].name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      userBloc.users[index].address,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
          listener: (context, state) {}),
    );
  }
}
