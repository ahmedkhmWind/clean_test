import 'package:dio/dio.dart';
import 'package:clean_flutter_poc/core/api/api_config.dart';
import 'package:clean_flutter_poc/core/api/api_end_points.dart';
import 'package:clean_flutter_poc/core/errors/failure.dart';
import 'package:clean_flutter_poc/features/auth/login/data/models/login_response_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> loginUser(String username, String password);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;

  LoginRemoteDataSourceImpl({required this.dio}); // Use the configured Dio

  @override
  Future<LoginResponseModel> loginUser(String username, String password) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password, 'rememberMe': true},
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw ServerFailure('Failed to log in');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? 'Login error');
    }
  }
}
