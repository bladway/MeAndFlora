import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:me_and_flora/feature/camera/presentation/bloc/bloc.dart';

import 'widgets/button.dart';

@RoutePage()
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CameraBloc>(create: (_) => CameraBloc()),
        BlocProvider<LocationBloc>(
            create: (_) => LocationBloc()..add(LocationRequested())),
      ],
      child: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationLoadSuccess) {
            BlocProvider.of<CameraBloc>(context).add(CameraInitialized());
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              BlocBuilder<CameraBloc, CameraState>(
                builder: (context, state) {
                  if (state is CameraLoadInProcess ||
                      state is CameraCapturedLoadInProgress) {
                    return Container(
                      color: Colors.black,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is CameraLoadSuccess) {
                    return CameraPreview(state.controller);
                  }
                  if (state is CameraCapturedSuccess) {
                    return Image.file(state.file);
                  }
                  if (state is CameraLoadFailure) {
                    return Container(
                      color: Colors.black,
                      child: Center(
                          child: Text(
                        "Камера недоступна",
                        style: Theme.of(context).textTheme.titleSmall,
                      )),
                    );
                  }
                  return Container(
                    color: Colors.black,
                    child: Center(
                        child: Text(
                      "Камера недоступна",
                      style: Theme.of(context).textTheme.titleSmall,
                    )),
                  );
                },
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.arrow_back_ios),
                          iconSize: 24,
                          onPressed: () {
                            AutoTabsRouter.of(context).setActiveIndex(
                                AutoTabsRouter.of(context).previousIndex != null
                                    ? AutoTabsRouter.of(context).previousIndex!
                                    : 0);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 13,
                        child: Text(
                          "Фото будет видно другим пользователям",
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(children: [
                  const Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<CameraBloc>(context)
                            .add(CameraCaptured());
                        /*
                          cameraController.takePicture().then((XFile? file) {
                            if (mounted) {
                              if (file != null) {
                                debugPrint("Picture saved to ${file.path}");
                              }
                            }
                          });*/
                      },
                      child: const Button(icon: Icons.camera_alt_outlined),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const Button(icon: Icons.photo),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      /*
      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
          isImageSelected = true;
        });
      } else {
        debugPrint("User didn't pick any image.");
      }*/
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
