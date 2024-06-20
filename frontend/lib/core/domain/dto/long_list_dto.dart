import 'package:freezed_annotation/freezed_annotation.dart';

part 'long_list_dto.g.dart';

@JsonSerializable()
class LongListDto {
  const LongListDto({ required this.longs,});

  final List<int> longs;

  factory LongListDto.fromJson(Map<String, dynamic> json) =>
      _$LongListDtoFromJson(json);

  /// Connect the generated [_$LongListDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LongListDtoToJson(this);
}