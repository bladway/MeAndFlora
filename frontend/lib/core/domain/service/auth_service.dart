import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:get_ip_address/get_ip_address.dart';
import 'package:dio_interceptor_plus/dio_interceptor_plus.dart';
import 'package:me_and_flora/core/domain/service/locator.dart';
import 'package:me_and_flora/core/exception/auth_exception.dart';

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

  static Future<String?> readUserJwt() async {
    return _storage.read(key: 'jwt');
  }

  static Future<String?> readRefreshJwt() async {
    return _storage.read(key: 'jwtR');
  }

  static Future<String?> readAnonymousRefreshJwt() async {
    return _storage.read(key: 'AnonymousRefreshJwt');
  }

  static Future<bool> hasJwt() async {
    return await _storage.containsKey(key: 'jwt');
  }

  static Future<bool> hasRefreshJwt() async {
    return await _storage.containsKey(key: 'jwtR');
  }

  static Future<bool> hasAnonymousRefreshJwt() async {
    return await _storage.containsKey(key: 'AnonymousRefreshJwt');
  }

  static Future<void> saveUserJwt(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  static Future<void> saveUserJwtR(String token) async {
    await _storage.write(key: 'jwtR', value: token);
  }

  static Future<void> saveAnonymousRefreshJwt(String token) async {
    await _storage.write(key: 'AnonymousRefreshJwt', value: token);
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

  static Future<Account> checkResponse(Response<dynamic> response) async {
    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        return Account.fromJson(data);
      case 404:
        final json = jsonDecode(response.data);
        throw Exception(json);
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Account> loadUser() async {
    try {
      if (await hasJwt()) {
        final response = await api.get('$baseUrl/user/byJwt');
        final data = response.data as Map<String, dynamic>;
        return Account.fromJson(data);
      } else {
        throw Exception('Unauth exception');
      }
    } catch (_) {
      throw Exception('Error contacting the server!');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'jwtR');
  }

  static Future<bool> refreshToken({String keyStore = 'jwtR'}) async {
    final refreshToken = await _storage.read(key: keyStore);
    await _storage.delete(key: 'jwt');

    final response = await api.put(
      '$baseUrl/auth/refreshJwt',
      options: Options(
        headers: {'jwtR': refreshToken},
      ),
    );

    if (response.statusCode == 201) {
      await saveUserJwt(response.data['jwt']);
      await saveUserJwtR(response.data['jwtR']);
      if (keyStore.startsWith('AnonymousRefreshJwt')) {
        await saveAnonymousRefreshJwt(response.data['jwtR']);
      }
      return true;
    } else {
      await _storage.delete(key: 'jwt');
      await _storage.delete(key: 'jwtR');
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
    final String ipAddress = await getIpAddress();
    final response = await api.post('$baseUrl/auth/register',
        data: jsonEncode(
            {"login": login, "password": password, "ipAddress": ipAddress}));

    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        await saveUserJwt(data['jwt']);
        await saveUserJwtR(data['jwtR']);
        return loadUser();
      default:
        final json = jsonDecode(response.data);
        throw Exception(json);
    }
  }

  Future<Account> signIn(String login, String password) async {
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
      case 401:
        throw UserNotFoundException();
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Account> signInAnonymous() async {
    if (await hasAnonymousRefreshJwt()) {
      await refreshToken(keyStore: 'AnonymousRefreshJwt');
    }
    final String ipAddress = await getIpAddress();
    final response = await api.post('$baseUrl/auth/anonymousLogin',
        data: jsonEncode({"ipAddress": ipAddress}));
    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        await saveUserJwt(data['jwt']);
        await saveUserJwtR(data['jwtR']);
        await saveAnonymousRefreshJwt(data['jwtR']);
        return Account(login: 'Пользователь', role: AccessLevel.unauth_user);
      case 400:
        final json = jsonDecode(response.data);
        throw Exception(json);
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Account> editAccount(String prevLogin, String? login, String? password,
      String passwordConfirm) async {
    if (login == "" && password == "") {
      throw AccountEditException();
    }
    final Map<String, dynamic> data = {
      "newLogin": login,
      "newPassword": password,
      "oldPassword": passwordConfirm
    };
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
