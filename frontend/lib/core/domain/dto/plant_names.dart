import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_names.g.dart';

@JsonSerializable()
class PlantNames {
  const PlantNames({required this.strings});

  final List<dynamic> strings;

  factory PlantNames.fromJson(Map<String, dynamic> json) =>
      _$PlantNamesFromJson(json);
}