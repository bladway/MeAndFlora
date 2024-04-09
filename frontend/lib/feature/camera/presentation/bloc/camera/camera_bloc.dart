import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  List<CameraDescription> cameras = [];
  CameraController? _cameraController;
  final int direction = 0;

  CameraController? getController() => _cameraController;

  bool isInitialized() => _cameraController?.value.isInitialized ?? false;

  CameraBloc() : super(CameraInitial()) {
    on<CameraEvent>(
      (event, emit) async {
        if (event is CameraInitialized) {
          await _initializeCamera(event, emit);
        }
        if (event is CameraCaptured) {
          await _makePhoto(event, emit);
        }
      },
    );
  }

  Future<void> _initializeCamera(
      CameraInitialized event, Emitter<CameraState> emit) async {
    emit(CameraLoadInProcess());

    if (!isInitialized()) {
      try {
        cameras = await availableCameras();
      } on CameraException {
        emit(const CameraLoadFailure(errorMsg: "Camera not available"));
        return;
      }

      if (cameras.isEmpty) {
        emit(const CameraLoadFailure(errorMsg: "Not available cameras"));
        return;
      }

      _cameraController = CameraController(
        cameras[direction],
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _cameraController?.initialize();
      } on CameraException {
        _cameraController?.dispose();
        emit(const CameraLoadFailure(errorMsg: "Camera not available"));
        return;
      }
    }

    if (_cameraController != null) {
      emit(CameraLoadSuccess(controller: _cameraController!, direction: direction));
    }
  }

  Future<void> _makePhoto(
      CameraCaptured event, Emitter<CameraState> emit) async {
    emit(CameraCapturedLoadInProgress());
    try {
      XFile photo = await _cameraController!.takePicture();
      emit(CameraCapturedSuccess(file: File(photo.path)));
      //return File(photo.path);
    } catch (e) {
      emit(CameraCapturedFailed());
      //return Future.error(e);
    }
  }
}
