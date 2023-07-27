import 'package:auto_route/auto_route.dart';
import 'package:demo/controller/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/bloc/user_bloc/user_bloc.dart';
import '../models/user_model.dart';

@RoutePage()
class DetailScreen extends StatefulWidget {
  const DetailScreen({required this.detail, super.key});
  final User detail;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  UserController userController = UserController();
  final UserBloc userBloc = UserBloc();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scafKey = GlobalKey();

  bool isReload = false;
  User valueBack = User(name: "", avatar: "", address: "", id: "");

  Future<void> updateUser() async {
    final Map<String, String> dataUpdate = {
      "id": widget.detail.id,
      "avatar": widget.detail.avatar,
      "name": _nameController.text,
      "address": _addressController.text
    };

    if (formKey.currentState!.validate()) {
      await userController.updateUser(widget.detail.id, dataUpdate);
      if (context.mounted) {
        isReload = true;
        valueBack = User(
            id: widget.detail.id,
            avatar: widget.detail.avatar,
            name: _nameController.text,
            address: _addressController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Edit Success"),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.detail.name;
    _addressController.text = widget.detail.address;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scafKey,
        appBar: AppBar(
          title: const Text('Detail'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              isReload == true
                  ? AutoRouter.of(context).pop(valueBack)
                  : AutoRouter.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  child: Image(
                    image: NetworkImage(widget.detail.avatar),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name can not empty';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Address can not empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    updateUser();
                  },
                  child: const Text('Edit'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return CupertinoAlertDialog(
                            title: const Text('Do you want to delete?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await userController
                                      .deleteUser(widget.detail.id);
                                  if (context.mounted) {
                                    isReload = true;
                                    // AutoRouter.of(context).popUntil((route) {
                                    //   route.settings.name == HomeRoute.name;
                                    //   value;
                                    //   return true;
                                    // });
                                    String value = widget.detail.id;
                                    Navigator.pop(context);
                                    AutoRouter.of(context).pop(value);
                                  }
                                },
                                child: const Text('Delete'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
