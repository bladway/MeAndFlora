import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:me_and_flora/core/domain/models/plant_type.dart';

part 'plant.g.dart';

@JsonSerializable()
class Plant {
  String name;
  PlantType type;
  String description;
  double? lon;
  double? lat;
  DateTime? date;
  bool isTracked;
  String imageUrl;

  Plant(
      {this.name = "Неизвестно",
      this.type = PlantType.unknown,
      this.description = "Описание отсутствует",
      this.lon,
      this.lat,
      this.date,
      this.isTracked = false,
      required this.imageUrl});

  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);

  /// Connect the generated [_$PlantToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PlantToJson(this);

  Plant copyWith({
    String? name,
    PlantType? type,
    String? description,
    double? lon,
    double? lat,
    DateTime? date,
    bool? isTracked,
    String? imageUrl,
  }) {
    return Plant(
        name: name ?? this.name,
        type: type ?? this.type,
        description: description ?? this.description,
        lon: lon ?? this.lon,
        lat: lat ?? this.lat,
        date: date ?? this.date,
        isTracked: isTracked ?? this.isTracked,
        imageUrl: imageUrl ?? this.imageUrl);
  }
}
