import 'dart:typed_data';

import 'package:app/constants/constants.dart';
import 'package:app/models/auth/auth_responses.dart';
import 'package:app/models/chat_response.dart';
import 'package:app/models/dictionary_response.dart';
import 'package:app/models/enhancer_response.dart';
import 'package:app/models/irab_response.dart';
import 'package:app/models/msa_response.dart';
import 'package:app/models/quran_response.dart';
import 'package:app/models/tashkeel_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  static AuthService? _instance;

  factory AuthService() => _instance ??= AuthService._();

  AuthService._();

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: Constants.apiBaseUrl,
    ));

    return dio;
  }

  final Dio dio = createDio();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      print(response.data);
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<RegisterResponse> register(
      String name, String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'fullName': name,
        },
      );

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> me(String token) async {
    try {
      final response = await dio.get('/user/me',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));

      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
