import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:me_and_flora/core/domain/models/plant_type.dart';

part 'plant.g.dart';

@JsonSerializable()
class Plant {
  final String name;
  @JsonKey(fromJson: _plantTypeFromJson, toJson: _plantTypeToJson)
  final PlantType type;
  final String description;
  final double? lon;
  final double? lat;
  final DateTime? date;
  bool subscribed;
  String path;

  Plant({
    this.name = "Неизвестно",
    this.type = PlantType.unknown,
    this.description = "Описание отсутствует",
    this.lon,
    this.lat,
    this.date,
    this.subscribed = false,
    this.path = "",
  });

  factory Plant.fromJson(Map<String, dynamic> json) =>
      _$PlantFromJson(json);

  /// Connect the generated [_$PlantToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PlantToJson(this);

  static PlantType _plantTypeFromJson(String json) {
    for (PlantType name in PlantType.values) {
      if (name.displayTitle.endsWith(json)) {
        return name;
      }
    }
    return PlantType.unknown;
  }

  static String _plantTypeToJson(PlantType object) {
    return object.displayTitle;
  }

  // factory Plant.fromJson(Map<dynamic, dynamic> json) {
  //   late double? lon;
  //   late double? lat;
  //
  //   if (json['coord']) {
  //     lon = json['coord']['lon'];
  //     lat = json['coord']['lat'];
  //   }
  //
  //   return Plant(
  //     name: json['name'],
  //     description: json['description'],
  //     lon: lon,
  //     lat: lat,
  //     type: json['type'],
  //     subscribed: json['subscribed'],
  //     image: json['path'] ?? '',
  //   );
  // }
  //
  // /// Connect the generated [_$PlantToJson] function to the `toJson` method.
  // //Map<String, dynamic> toJson() => _$PlantToJson(this);
  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'description': description,
  //     'type': type,
  //     'subscribed': subscribed,
  //     'image': image
  //   };
  // }


  Plant copyWith({
    String? name,
    PlantType? type,
    String? description,
    double? lon,
    double? lat,
    DateTime? date,
    bool? subscribed,
    String? image
  }) {
    return Plant(
        name: name ?? this.name,
        type: type ?? this.type,
        description: description ?? this.description,
        lon: lon ?? this.lon,
        lat: lat ?? this.lat,
        date: date ?? this.date,
        subscribed: subscribed ?? this.subscribed,
        path: image ?? this.path);
  }
}
