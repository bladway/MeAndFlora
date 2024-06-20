import 'package:dio/dio.dart';
import 'package:me_and_flora/core/domain/api/api_key.dart';
import 'package:me_and_flora/core/domain/dto/long_list_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_file_client.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestFileClient {
  factory RestFileClient(Dio dio, {String baseUrl}) = _RestFileClient;

  @GET('/file/byPath')
  Future<LongListDto> getImageByPath(
    @Query('imagePath') String imagePath,
  );
}
