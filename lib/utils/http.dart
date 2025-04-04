import 'package:dio/dio.dart';

final dio = Dio();

class Request {
  static Future get(String path) {
    return dio.get(path);
  }
}
