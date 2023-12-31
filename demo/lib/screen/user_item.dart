import 'package:flutter/material.dart';

import '../core/bloc/user_bloc/user_bloc.dart';

class UserItem extends StatelessWidget {
  final UserBloc userBloc;
  final int index;
  final Color? color;

  const UserItem({
    super.key,
    required this.userBloc,
    required this.index,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: color,
      width: MediaQuery.sizeOf(context).width - 10,
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            child: Image(
              image: NetworkImage(userBloc.users[index].avatar),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                userBloc.users[index].address,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
