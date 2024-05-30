import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/api/api_key.dart';
import 'package:me_and_flora/core/domain/dto/plant_names.dart';
import 'package:me_and_flora/core/domain/dto/string_dto.dart';
import 'package:me_and_flora/core/domain/dto/user_info_dto_list.dart';
import 'package:me_and_flora/core/domain/models/account.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_user_client.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestUserClient {
  factory RestUserClient(Dio dio, {String baseUrl}) = _RestUserClient;

  @POST('/user/seeAdvert')
  Future<int> seeAdvertisement();

  @POST('/user/create')
  Future<Account> createAccountByAdmin({@Body() required Account account});

  @GET('/user/allByAdmin')
  Future<UserInfoDtoList> getAccounts(
    @Query('page') int? page,
    @Query('size') int? size,
  );

  @GET('/user/getByJwt')
  Future<Account> getAccount();

  @DELETE('/user/delete')
  Future<StringDto> deleteUser({@Body() required StringDto string});
}
