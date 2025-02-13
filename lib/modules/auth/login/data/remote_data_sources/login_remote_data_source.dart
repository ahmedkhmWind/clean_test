import 'package:clean_flutter_poc/core/failure.dart';
import 'package:clean_flutter_poc/modules/auth/login/data/models/login_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> loginUser(String username, String password);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final http.Client client;

  LoginRemoteDataSourceImpl({required this.client});

  @override
  Future<LoginResponseModel> loginUser(String username, String password) async {
    final response = await client.post(
      Uri.parse(
          'https://support.wind-erp.com/api/wind-auth/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password,'rememberMe':true}),
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure('Failed to log in');
    }
  }
}