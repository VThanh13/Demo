import 'package:demo/core/service/user_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class UserController {
  List<User> user = [];
  List<User> moreItems = [User(name: "", avatar: "", address: "", id: "")];

  final baseUrl = 'https://64bdcfeb2320b36433c7d728.mockapi.io/users';

  bool isLoadMore = true;

  Future<void> getUserInfo() async {
    try {
      final response = await UserService().getUser('$baseUrl?page=1&limit=10');
      if (response.statusCode == 200) {
        user.clear();
        user.addAll((response.data ?? []).map((e) => User.fromJson(e)));
      } else {
        if (kDebugMode) {
          print('API failed with status code: ${response.statusCode}');
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        if (kDebugMode) {
          print('API call timeout');
        } else {
          if (kDebugMode) {
            print('API call failed with error: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('API call failed with exception: $e');
      }
    }
  }

  Future<void> loadMoreUser(int page) async {
    try {
      final response =
          await UserService().getUser('$baseUrl?page=$page&limit=6');
      if (response.statusCode == 200) {
        if (response.data!.isNotEmpty) {
          isLoadMore = true;
          moreItems.clear();
          moreItems.addAll((response.data ?? []).map((e) => User.fromJson(e)));
          user.addAll(moreItems);
        } else {
          isLoadMore = false;
          moreItems.clear();
        }
      } else {
        if (kDebugMode) {
          print('API failed with status code: ${response.statusCode}');
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        if (kDebugMode) {
          print('API call timeout');
        } else {
          if (kDebugMode) {
            print('API call failed with error: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('API call failed with exception: $e');
      }
    }
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      String url = '$baseUrl/$id';

      await UserService().editUser(url, data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        if (kDebugMode) {
          print('API call timeout');
        }
      } else {
        if (kDebugMode) {
          print('API call failed with error: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('API call failed with exception: $e');
      }
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      String url = '$baseUrl/$id';

      await UserService().deleteUser(url);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        if (kDebugMode) {
          print('API call timeout');
        }
      } else {
        if (kDebugMode) {
          print('API call failed with error: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('API call failed with exception: $e');
      }
    }
  }
}
