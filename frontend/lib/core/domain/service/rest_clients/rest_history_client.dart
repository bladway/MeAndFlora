import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/api/api_key.dart';
import 'package:me_and_flora/core/domain/dto/long_list_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_history_client.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestHistoryClient {
  factory RestHistoryClient(Dio dio, {String baseUrl}) = _RestHistoryClient;

  @GET('/history/allByUser')
  Future<LongListDto> getHistory(
      @Query('page') int? page,
      @Query('size') int? size,
      );
}