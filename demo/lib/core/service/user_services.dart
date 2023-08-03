import 'package:dio/dio.dart';

class UserService {
  Dio dio = Dio();

  Options options = Options(
    receiveTimeout: const Duration(milliseconds: 10000),
    sendTimeout: const Duration(milliseconds: 10000),
  );

  Future<Response<List<dynamic>>> getUser(String url) async {
    try {
      final res = await dio.get<List<dynamic>>(
        url,
        options: options,
      );
      return res;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('API receive timeout');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('API connection timeout');
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception('API send time out');
      } else {
        throw Exception('API call failed with error: $e');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<Map<String, dynamic>>> editUser(
      String url, Map<String, dynamic> data) async {
    try {
      final res = dio.put<Map<String, dynamic>>(
        url,
        data: data,
        options: options,
      );
      return res;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('API receive timeout');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('API connection timeout');
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception('API send time out');
      } else {
        throw Exception('API call failed with error: $e');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<Map<String, dynamic>>> deleteUser(String url) async {
    try {
      final res = await dio.delete<Map<String, dynamic>>(
        url,
        options: options,
      );
      return res;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('API receive timeout');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('API connection timeout');
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception('API send time out');
      } else {
        throw Exception('API call failed with error: $e');
      }
    } catch (e) {
      rethrow;
    }
  }
}
