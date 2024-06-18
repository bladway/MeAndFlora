import 'dart:async';

import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/service/auth_service.dart';

import '../api/api_key.dart';

class AppInterceptors extends InterceptorsWrapper {
  @override
  FutureOr<dynamic> onRequest(RequestOptions options, handler) async {
    if (!options.path.contains('https')) {
      options.baseUrl = baseUrl;
      options.path = options.path;
    }
    final jwt = await AuthService.readUserJwt();
    if (jwt != null && jwt.isNotEmpty) {
      options.headers['jwt'] = jwt;
    }
    return handler.next(options);
  }

  @override
  Future<dynamic> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (await AuthService.hasRefreshJwt()) {
        if (await AuthService.refreshToken()) {
          final jwt = await AuthService.readUserJwt();
          err.requestOptions.headers['jwt'] = '$jwt';
          return handler.resolve(await AuthService.retry(err.requestOptions));
        } else {
          return;
        }
      }
    }
    return handler.next(err);
  }
}
