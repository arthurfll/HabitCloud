import 'package:dio/dio.dart';

import '../auth/auth_service.dart';
import '../config/env.dart';
import '../models/sync_models.dart';

class ApiClient {
  static final ApiClient instance = ApiClient._();

  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl, connectTimeout: const Duration(seconds: 15)));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthService.instance.currentAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getCategoryOptions() async {
    final response = await _dio.get('/api/metadata/category-options');
    return response.data as Map<String, dynamic>;
  }

  Future<SyncResponse> sync(SyncRequest request) async {
    final response = await _dio.post('/api/sync', data: request.toJson());
    return SyncResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
