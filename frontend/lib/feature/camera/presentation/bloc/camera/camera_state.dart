import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoadInProcess extends CameraState {}

class CameraLoadSuccess extends CameraState {
  final CameraController controller;
  final int direction;

  const CameraLoadSuccess({required this.controller, required this.direction});
}

class CameraLoadFailure extends CameraState {
  final String errorMsg;

  const CameraLoadFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

class CameraCapturedLoadInProgress extends CameraState {}

class CameraCapturedSuccess extends CameraState {
  final File file;

  const CameraCapturedSuccess({required this.file});

  @override
  List<Object> get props => [file];
}

class CameraCapturedFailed extends CameraState {}
