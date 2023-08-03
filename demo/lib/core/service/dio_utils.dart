import 'package:dio/dio.dart';

class DioUtils {
  Dio dio = Dio();

  Options options = Options(
    receiveTimeout: const Duration(milliseconds: 10000),
    sendTimeout: const Duration(milliseconds: 10000),
  );

  Future<Response> get(String url) async {
    try {
      final response = await dio.get(url, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> update(String url, dynamic data) async {
    try {
      final response = await dio.put(
        url,
        data: data,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String url) async {
    try {
      final response = await dio.delete(
        url,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class ErrorHandle {
  static handleError(e) {
    if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('API receive timeout');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('API connection timeout');
    } else if (e.type == DioExceptionType.sendTimeout) {
      throw Exception('API send time out');
    } else {
      throw Exception('API call failed with error: $e');
    }
  }
}
