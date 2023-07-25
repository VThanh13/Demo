import 'package:dio/dio.dart';

class UserService {
  Dio dio = Dio();

  Future<Response<List<dynamic>>> getUser(String url) async {
    final res = await dio.get<List<dynamic>>(
      url,
      options: Options(
        receiveTimeout: const Duration(milliseconds: 10000),
        sendTimeout: const Duration(microseconds: 10000),
      ),
    );
    return res;
  }

  Future<Response<Map<String, dynamic>>> editUser(
      String url, Map<String, dynamic> data) async {
    final res = dio.put<Map<String, dynamic>>(
      url,
      data: data,
      options: Options(
        receiveTimeout: const Duration(milliseconds: 10000),
        sendTimeout: const Duration(milliseconds: 10000),
      ),
    );
    return res;
  }

  Future<Response<Map<String, dynamic>>> deleteUser(String url) async {
    final res = await dio.delete<Map<String, dynamic>>(
      url,
      options: Options(
        receiveTimeout: const Duration(milliseconds: 10000),
        sendTimeout: const Duration(milliseconds: 10000),
      ),
    );
    return res;
  }
}
