import 'package:clean_flutter_poc/core/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Using SharedPreferences

class ApiConfig {
  static Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: "${AppConstants.baseUrl}/api",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(LogInterceptor(responseBody: true)); // Debugging
    dio.interceptors.add(AuthInterceptor(dio)); // Token handling

    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Check if the login response contains a token and save it
    if (response.requestOptions.path.contains("/authenticate") &&
        response.statusCode == 200) {
      final token = response.data["access_token"];
      if (token != null) {
        await _saveToken(token);
      }
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle token expiration (e.g., logout or refresh token)
    }
    return handler.next(err);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
