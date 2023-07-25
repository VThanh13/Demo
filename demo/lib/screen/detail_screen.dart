import 'package:auto_route/auto_route.dart';
import 'package:demo/controller/user_controller.dart';
import 'package:flutter/material.dart';

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

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.detail.name;
    _addressController.text = widget.detail.address;
  }

  UserController userController = UserController();

  final GlobalKey<ScaffoldMessengerState> scafKey = GlobalKey();

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
                    final Map<String, String> dataUpdate = {
                      "id": widget.detail.id,
                      "avatar": widget.detail.avatar,
                      "name": _nameController.text,
                      "address": _addressController.text
                    };
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      await userController.updateUser(
                          widget.detail.id, dataUpdate);
                      if (context.mounted) {
                        AutoRouter.of(context).pop();
                        //showSnackBar by context
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Edit Success"),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Edit'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    await userController.deleteUser(widget.detail.id);
                    if (context.mounted) {
                      //Navigate by context
                      //context.popRoute();
                      //Navigate by AutoRouter
                      AutoRouter.of(context).pop();
                      //showSnackBar by context
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete Success"),
                        ),
                      );
                      //showSnackBar by global key
                      // scafKey.currentState!.showSnackBar(
                      //   const SnackBar(
                      //     content: Text("Delete Success"),
                      //   ),
                      // );
                    }
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
