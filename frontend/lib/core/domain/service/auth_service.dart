import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:get_ip_address/get_ip_address.dart';

import '../api/api_key.dart';
import '../models/models.dart';

class AuthService {
  static final Dio api = Dio();

  //static String? accessToken;

  static const _storage = storage.FlutterSecureStorage();

  AuthService() {
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      if (!options.path.contains('https')) {
        //options.baseUrl = baseUrl;
        options.path = '$baseUrl${options.path}';
      }
      final jwt = await _storage.read(key: 'jwt');
      options.headers['Authorization'] = 'Bearer $jwt';
      return handler.next(options);
    }, onError: (DioException exception, handler) async {
      if (exception.response?.statusCode == 403) {
        if (await _storage.containsKey(key: 'jwtR')) {
          if (await refreshToken()) {
            final jwt = await _storage.read(key: 'jwt');
            exception.requestOptions.headers['Authorization'] = 'Bearer $jwt';
            return handler.resolve(await _retry(exception.requestOptions));
          }
        }
      }
      return handler.next(exception);
    }));
  }

  static Future<void> saveUserJwt(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  static Future<void> saveUserJwtR(String token) async {
    await _storage.write(key: 'jwtR', value: token);
  }

  static Future<void> saveAnonymousJwt(String token) async {
    await _storage.write(key: 'AnonymousJwt', value: token);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  static Future<Account> loadUser() async {
    final response = await api.get('$baseUrl/auth/users');

    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        return Account.fromJson(data);
      case 400:
        final json = jsonDecode(response.data);
        throw Exception(json);
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  static Future<bool> refreshToken() async {
    final refreshToken = await _storage.read(key: 'jwtR');
    final response =
        await api.post('/auth/refresh', data: {'jwtR': refreshToken});

    if (response.statusCode == 201) {
      await saveUserJwt(response.data['jwt']);
      await saveUserJwtR(response.data['jwtR']);
      return true;
    } else {
      await logout();
      return false;
    }
  }

  Future<String> getIpAddress() async {
    try {
      var ipAddress = IpAddress();
      dynamic data = await ipAddress.getIpAddress();
      return data.toString();
    } on IpAddressException catch (exception) {
      throw IpAddressException(exception.message);
    }
  }

  // Future<Account> getAccount(String login) async {
  //   return Account(login: login, accessLevel: AccessLevel.user);
  // }

  Future<Account> signUp(String login, String password) async {
    final String ipAddress = await getIpAddress();
    final response = await Dio().post('/auth/register',
        data: jsonEncode(
            {"login": login, "password": password, "ipAddress": ipAddress}));

    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        await saveUserJwt(data['jwt']);
        await saveUserJwtR(data['jwtR']);
        if (data.containsKey('AnonymousJwt')) {
          await saveAnonymousJwt(data['AnonymousJwt']);
        }
        //return loadUser();
        return Account(login: login, accessLevel: AccessLevel.user);
      case 400:
        final json = jsonDecode(response.data);
        throw Exception(json);
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Account> signIn(String login, String password) async {
    // if (login == "admin_" && pass == "admin_") {
    //   return Account(
    //       login: "admin_", password: "admin_", accessLevel: AccessLevel.admin);
    // } else if (login == "botanic" && pass == "botanic") {
    //   return Account(
    //       login: "botanic",
    //       password: "botanic",
    //       accessLevel: AccessLevel.botanic);
    // } else if (login == "user__" && pass == "user__") {
    //   return Account(
    //       login: "user__", password: "user__", accessLevel: AccessLevel.user);
    // } else {
    //   throw UserNotFoundException();
    // }
    final String ipAddress = await getIpAddress();
    final response = await Dio().post('$baseUrl/auth/login',
        data: jsonEncode(
            {"login": login, "password": password, "ipAddress": ipAddress}));
    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        await saveUserJwt(data['jwt']);
        await saveUserJwtR(data['jwtR']);
        if (data.containsKey('AnonymousJwt')) {
          await saveAnonymousJwt(data['AnonymousJwt']);
        }
        //return loadUser();
        return Account(login: login, accessLevel: AccessLevel.user);
      case 400:
        final json = jsonDecode(response.data);
        throw Exception(json);
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  bool isLoggedIn() {
    return true;
  }
}
