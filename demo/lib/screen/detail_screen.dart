import 'package:auto_route/auto_route.dart';
import 'package:demo/controller/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/bloc/user_bloc/user_bloc.dart';
import '../core/common/loading_dialog.dart';
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
  final globalKey = GlobalKey<ScaffoldMessengerState>();

  bool isReload = false;
  late User valueBack;
  bool? isDeleting;

  ValueNotifier<bool> isDelete = ValueNotifier(false);

  Future<void> updateUser() async {
    final Map<String, String> dataUpdate = {
      "id": widget.detail.id,
      "avatar": widget.detail.avatar,
      "name": _nameController.text,
      "address": _addressController.text
    };

    if (formKey.currentState!.validate()) {
      try {
        await userController
            .updateUser(widget.detail.id, dataUpdate)
            .whenComplete(
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Edit Success"),
                ),
              ),
            );
        if (context.mounted) {
          isReload = true;
          valueBack = widget.detail.copyWith(
            name: _nameController.text,
            address: _addressController.text,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Edit Failed"),
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
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: const Text('Detail'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              AutoRouter.of(context).pop(isReload == true ? valueBack : null);
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
                  onPressed: () async {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (builder) {
                          return const LoadingDialog();
                        });

                    await updateUser().whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Edit'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (builder) {
                          return ValueListenableBuilder(
                              valueListenable: isDelete,
                              builder: (context, delete, _) {
                                return CupertinoAlertDialog(
                                  title: Text(isDelete.value == true
                                      ? 'Deleting'
                                      : 'Do you want to delete?'),
                                  actions: [
                                    if (isDelete.value == false)
                                      TextButton(
                                        onPressed: () async {
                                          isDelete.value = true;
                                          try {
                                            await userController
                                                .deleteUser(widget.detail.id)
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                              if (context.mounted) {
                                                isReload = true;
                                                // AutoRouter.of(context).popUntil((route) =>
                                                //     route.settings.name == HomeRoute.name);
                                                String value = widget.detail.id;
                                                AutoRouter.of(context)
                                                    .pop(value);
                                              }
                                            });
                                          } catch (e) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("Delete Failed"),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    if (isDelete.value == false)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    if (isDelete.value == true)
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                          ),
                                          child: CircularProgressIndicator
                                              .adaptive(),
                                        ),
                                      ),
                                  ],
                                );
                              });
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
