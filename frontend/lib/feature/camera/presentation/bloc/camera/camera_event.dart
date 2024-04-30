import 'package:equatable/equatable.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CameraInitialized extends CameraEvent {}

class CameraStopped extends CameraEvent {}

class CameraCaptured extends CameraEvent {}

class GalleryLoaded extends CameraEvent {}

/*
class CameraCaptured extends CameraEvent {
  final XFile file;

  const CameraCaptured(this.file);

  @override
  List<Object> get props => [file];
}*/
