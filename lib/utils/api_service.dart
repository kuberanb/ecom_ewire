import 'package:dio/dio.dart';
import 'package:ecom/utils/api_end_points.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiEndPoints.baseUrl));

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }
}
