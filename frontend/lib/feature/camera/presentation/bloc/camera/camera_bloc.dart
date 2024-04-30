import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
        if (event is GalleryLoaded) {
          await _pickPhoto(event, emit);
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
      _cameraController!.setFlashMode(FlashMode.off);
      emit(CameraLoadSuccess(controller: _cameraController!, direction: direction));
    }
  }

  Future<void> _makePhoto(
      CameraCaptured event, Emitter<CameraState> emit) async {
    emit(CameraPhotoLoadInProgress());
    try {
      final photo = await _cameraController!.takePicture();
      emit(PhotoLoadedSuccess(imagePath: photo.path));
    } catch (e) {
      debugPrint(e.toString());
      add(CameraInitialized());
    }
  }

  Future<void> _pickPhoto(
      GalleryLoaded event, Emitter<CameraState> emit) async {
    emit(CameraPhotoLoadInProgress());
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery);
      if (image != null) {
        emit(PhotoLoadedSuccess(imagePath: image.path));
      }
    } catch (e) {
      debugPrint(e.toString());
      add(CameraInitialized());
    }
  }
}
