import 'package:demo/core/service/user_services.dart';

class UserController {
  final baseUrl = 'https://64bdcfeb2320b36433c7d728.mockapi.io/users';

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      String url = '$baseUrl/$id';
      await UserService().editUser(url, data);
    } catch (e) {
      throw Exception('API call failed with exception: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      String url = '$baseUrl/$id';
      await UserService().deleteUser(url);
    } catch (e) {
      throw Exception('API call failed with exception: $e');
    }
  }
}
