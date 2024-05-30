import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:get_ip_address/get_ip_address.dart';
import 'package:dio_interceptor_plus/dio_interceptor_plus.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';

import '../../exception/account_exception.dart';
import '../api/api_key.dart';
import '../models/models.dart';

class AuthService {

  static final Dio api = locator.get(instanceName: 'dio');

  static const _storage = storage.FlutterSecureStorage();

  const AuthService({required this.wrapper});

  final InterceptorsWrapper wrapper;

  void init() {
    api.interceptors.add(wrapper);
    api.interceptors.add(LoggingInterceptor());
  }

  void dispose() {
    api.interceptors.remove(wrapper);
    api.interceptors.remove(LoggingInterceptor());
  }

  // AuthService() {
  //   api.interceptors
  //       .add(InterceptorsWrapper(onRequest: (options, handler) async {
  //     if (!options.path.contains('https')) {
  //       //options.baseUrl = baseUrl;
  //       options.path = '$baseUrl${options.path}';
  //     }
  //     final jwt = await _storage.read(key: 'jwt');
  //     //options.headers['Authorization'] = 'Bearer $jwt';
  //     options.headers['jwt'] = '$jwt';
  //     return handler.next(options);
  //   }, onError: (DioException exception, handler) async {
  //     if (exception.response?.statusCode == 403) {
  //       if (await _storage.containsKey(key: 'jwtR')) {
  //         if (await refreshToken()) {
  //           final jwt = await _storage.read(key: 'jwt');
  //           //exception.requestOptions.headers['Authorization'] = 'Bearer $jwt';
  //           exception.requestOptions.headers['jwt'] = '$jwt';
  //           return handler.resolve(await _retry(exception.requestOptions));
  //         }
  //       }
  //     }
  //     return handler.next(exception);
  //   }));
  //   api.interceptors.add(LoggingInterceptor());
  // }

  static Future<String?> readUserJwt() async {
    return _storage.read(key: 'jwt');
  }

  static Future<bool> hasUserJwt() async {
    return await _storage.containsKey(key: 'jwtR');
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

  static Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return AuthService.api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  static Account checkResponse(Response<dynamic> response) {
    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        return Account.fromJson(data);
      case 401:
        final json = jsonDecode(response.data);
        throw Exception(json);
      case 404:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Account> loadUser() async {
    final jwt = await _storage.read(key: 'jwt');
    api.options.headers.addAll({'jwt': jwt});
    final response = await api.get('$baseUrl/user/byJwt');

    /*
     wrapper: InterceptorsWrapper(onRequest: (options, handler) async {
      if (!options.path.contains('https')) {
        options.baseUrl = baseUrl;
        options.path = options.path;
      }
      final jwt = await _storage.read(key: 'jwt');
      options.headers['jwt'] = '$jwt';
      return handler.next(options);
    }, onError: (DioException exception, handler) async {
      if (exception.response?.statusCode == 403) {
        if (await _storage.containsKey(key: 'jwtR')) {
          if (await refreshToken()) {
            final jwt = await _storage.read(key: 'jwt');
            exception.requestOptions.headers['jwt'] = '$jwt';
            return handler.resolve(await retry(exception.requestOptions));
          }
        }
      }
      return handler.next(exception);
    })
     */
    return checkResponse(response);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  static Future<bool> refreshToken() async {
    final refreshToken = await _storage.read(key: 'jwtR');
    final response =
        await api.put('$baseUrl/auth/refreshJwt', data: {'jwtr': refreshToken});

    if (response.statusCode == 201) {
      await saveUserJwt(response.data['jwt']);
      await saveUserJwtR(response.data['jwtR']);
      return true;
    } else {
      await _storage.deleteAll();
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

  Future<Account> signUp(String login, String password) async {
    await logout();
    final String ipAddress = await getIpAddress();
    final response = await api.post('$baseUrl/auth/register',
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
        return loadUser();
      default:
        final json = jsonDecode(response.data);
        throw Exception(json);
    }
  }

  Future<Account> signIn(String login, String password) async {
    await logout();
    final String ipAddress = await getIpAddress();
    final response = await api.post('$baseUrl/auth/userLogin',
        data: jsonEncode(
            {"login": login, "password": password, "ipAddress": ipAddress}));
    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        await saveUserJwt(data['jwt']);
        await saveUserJwtR(data['jwtR']);
        return loadUser();
      case 400:
        final json = jsonDecode(response.data);
        throw Exception(json);
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Account> signInAnonymous() async {
    await logout();
    final String ipAddress = await getIpAddress();
    final response = await api.post('$baseUrl/auth/anonymousLogin',
        data: jsonEncode({"ipAddress": ipAddress}));
    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        await saveUserJwt(data['jwt']);
        await saveUserJwtR(data['jwtR']);
        if (data.containsKey('AnonymousJwt')) {
          await saveAnonymousJwt(data['AnonymousJwt']);
        }
        return Account(login: 'Пользователь', role: AccessLevel.unauth_user);
      case 400:
        final json = jsonDecode(response.data);
        throw Exception(json);
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Account> editAccount(String prevLogin, String? login, String? password,
      String passwordConfirm) async {
    if (login == "" && password == "") {
      throw AccountEditException();
    }
    //final dio = AuthService.api;
    final Map<String, dynamic> data = {
      "newLogin": login,
      "newPassword": password,
      "oldPassword": passwordConfirm
    };
    //final jwt = await _storage.read(key: 'jwt');
    //dio.options.headers.addAll({'jwt': jwt});
    final response =
        await api.patch("$baseUrl/auth/changeData", data: jsonEncode(data));
    switch (response.statusCode) {
      case 200:
        return await loadUser();
      default:
        throw Exception('Error contacting the server!');
    }
  }
}
