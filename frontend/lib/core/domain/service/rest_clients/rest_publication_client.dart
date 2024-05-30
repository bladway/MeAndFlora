import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/api/api_key.dart';
import 'package:me_and_flora/core/domain/dto/long_list_dto.dart';
import 'package:me_and_flora/core/domain/dto/number_dto.dart';
import 'package:me_and_flora/core/domain/models/models.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_publication_client.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestPublicationClient {
  factory RestPublicationClient(Dio dio, {String baseUrl}) = _RestPublicationClient;

  @GET('/publication/allByAdmin')
  Future<LongListDto> getPublicIdsByAdmin(
      @Query('page') int? page,
      @Query('size') int? size,
      );

  //не задавайте вопросов, этот запрос получает список id подписок для конкретных пользователей
  @GET('/publication/allByUser')
  Future<LongListDto> getPublicIdsByUser(
      @Query('page') int? page,
      @Query('size') int? size,
      );

  @DELETE('/publication/delete')
  Future<NumberDto> deletePublication({@Body() required NumberDto number});
}