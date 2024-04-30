import 'dart:math';

class StatisticService {
  Future<Map> getIdentStatistic(DateTime? start, DateTime? end) async {
    if (start == null || end == null) {
      throw Exception();
    }
    Map data = <dynamic, dynamic>{};
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      data.addAll({start.add(Duration(days: i)) : Random().nextInt(500)});
    }
    return data;
  }

  Future<Map> getAdWatchStatistic(DateTime? start, DateTime? end) async {
    if (start == null || end == null) {
      throw Exception();
    }
    Map data = <dynamic, dynamic>{};
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      data.addAll({start.add(Duration(days: i)) : Random().nextInt(500)});
    }
    return data;
  }
}
