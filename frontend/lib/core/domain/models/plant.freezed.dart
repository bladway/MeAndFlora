// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Plant _$PlantFromJson(Map<String, dynamic> json) {
  return _Plant.fromJson(json);
}

/// @nodoc
mixin _$Plant {
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get lon => throw _privateConstructorUsedError;
  String? get lat => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  bool get isTracked => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlantCopyWith<Plant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantCopyWith<$Res> {
  factory $PlantCopyWith(Plant value, $Res Function(Plant) then) =
      _$PlantCopyWithImpl<$Res, Plant>;
  @useResult
  $Res call(
      {String name,
      String type,
      String description,
      String? lon,
      String? lat,
      DateTime? date,
      bool isTracked,
      String imageUrl});
}

/// @nodoc
class _$PlantCopyWithImpl<$Res, $Val extends Plant>
    implements $PlantCopyWith<$Res> {
  _$PlantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? description = null,
    Object? lon = freezed,
    Object? lat = freezed,
    Object? date = freezed,
    Object? isTracked = null,
    Object? imageUrl = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isTracked: null == isTracked
          ? _value.isTracked
          : isTracked // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantImplCopyWith<$Res> implements $PlantCopyWith<$Res> {
  factory _$$PlantImplCopyWith(
          _$PlantImpl value, $Res Function(_$PlantImpl) then) =
      __$$PlantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String type,
      String description,
      String? lon,
      String? lat,
      DateTime? date,
      bool isTracked,
      String imageUrl});
}

/// @nodoc
class __$$PlantImplCopyWithImpl<$Res>
    extends _$PlantCopyWithImpl<$Res, _$PlantImpl>
    implements _$$PlantImplCopyWith<$Res> {
  __$$PlantImplCopyWithImpl(
      _$PlantImpl _value, $Res Function(_$PlantImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? description = null,
    Object? lon = freezed,
    Object? lat = freezed,
    Object? date = freezed,
    Object? isTracked = null,
    Object? imageUrl = null,
  }) {
    return _then(_$PlantImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isTracked: null == isTracked
          ? _value.isTracked
          : isTracked // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlantImpl extends _Plant with DiagnosticableTreeMixin {
  const _$PlantImpl(
      {required this.name,
      required this.type,
      required this.description,
      this.lon,
      this.lat,
      this.date,
      this.isTracked = false,
      required this.imageUrl})
      : super._();

  factory _$PlantImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlantImplFromJson(json);

  @override
  final String name;
  @override
  final String type;
  @override
  final String description;
  @override
  final String? lon;
  @override
  final String? lat;
  @override
  final DateTime? date;
  @override
  @JsonKey()
  final bool isTracked;
  @override
  final String imageUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Plant(name: $name, type: $type, description: $description, lon: $lon, lat: $lat, date: $date, isTracked: $isTracked, imageUrl: $imageUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Plant'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('lon', lon))
      ..add(DiagnosticsProperty('lat', lat))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('isTracked', isTracked))
      ..add(DiagnosticsProperty('imageUrl', imageUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.isTracked, isTracked) ||
                other.isTracked == isTracked) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, type, description, lon,
      lat, date, isTracked, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantImplCopyWith<_$PlantImpl> get copyWith =>
      __$$PlantImplCopyWithImpl<_$PlantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlantImplToJson(
      this,
    );
  }
}

abstract class _Plant extends Plant {
  const factory _Plant(
      {required final String name,
      required final String type,
      required final String description,
      final String? lon,
      final String? lat,
      final DateTime? date,
      final bool isTracked,
      required final String imageUrl}) = _$PlantImpl;
  const _Plant._() : super._();

  factory _Plant.fromJson(Map<String, dynamic> json) = _$PlantImpl.fromJson;

  @override
  String get name;
  @override
  String get type;
  @override
  String get description;
  @override
  String? get lon;
  @override
  String? get lat;
  @override
  DateTime? get date;
  @override
  bool get isTracked;
  @override
  String get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$PlantImplCopyWith<_$PlantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
