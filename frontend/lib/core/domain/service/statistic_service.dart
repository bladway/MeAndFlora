import 'dart:math';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:me_and_flora/core/domain/dto/stat_dto.dart';
import 'package:me_and_flora/core/domain/dto/stat_dto_list.dart';
import 'package:me_and_flora/core/domain/service/auth_service.dart';
import 'package:me_and_flora/core/domain/service/rest_clients/rest_statistic_client.dart';

class StatisticService {
  static final Dio dio = AuthService.api;

  final client = RestStatisticClient(dio);

  String convertDateTime(DateTime date) {
    var val = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(date);
    var offset = date.timeZoneOffset;
    var hours =
        offset.inHours > 0 ? offset.inHours : 1; // For fixing divide by 0

    if (!offset.isNegative) {
      val =
          "$val+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    } else {
      val =
          "$val-${(-offset.inHours).toString().padLeft(2, '0')}:${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    }

    return val;
  }

  Future<Map> getIdentStatistic(DateTime? start, DateTime? end) async {
    if (start == null || end == null || end.compareTo(start) < 0) {
      throw Exception();
    }

    String startOffset = convertDateTime(start);
    String endOffset = convertDateTime(end);

    StatDtoList statDtoList =
        await client.getRequestsStatistic(startOffset, endOffset, 0, 1000);
    List<StatDto> statDtos = statDtoList.statDtoList;
    Map data = <dynamic, dynamic>{};
    for (var val in statDtos) {
      data.addAll({val.date: val.count});
    }
    return data;
  }

  Future<Map> getAdWatchStatistic(DateTime? start, DateTime? end) async {
    if (start == null || end == null || end.compareTo(start) < 0) {
      throw Exception();
    }

    String startOffset = convertDateTime(start);
    String endOffset = convertDateTime(end);

    StatDtoList statDtoList =
        await client.getAdvertisementStatistic(startOffset, endOffset, 0, 1000);
    List<StatDto> statDtos = statDtoList.statDtoList;
    Map data = <dynamic, dynamic>{};
    for (var val in statDtos) {
      data.addAll({val.date: val.count});
    }
    return data;
  }
}
