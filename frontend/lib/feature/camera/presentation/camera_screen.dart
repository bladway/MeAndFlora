import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/presentation/bloc/plant_history/plant_history.dart';
import 'package:me_and_flora/core/theme/strings.dart';
import 'package:me_and_flora/feature/camera/presentation/bloc/bloc.dart';
import 'package:me_and_flora/feature/camera/presentation/widgets/advertisement.dart';

import '../../../core/domain/models/models.dart';
import '../../../core/presentation/bloc/plant_ident/plant_ident.dart';
import '../../../core/presentation/widgets/buttons/circle_button.dart';

@RoutePage()
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double? lon;
    double? lat;
    String? imageUrl;
    AppMetrica.reportEvent('Переход на страницу камеры');

    return BlocProvider<LocationBloc>(
      lazy: false,
      create: (_) => LocationBloc()..add(LocationRequested()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is LocationLoadSuccess) {
                lon = state.lon;
                lat = state.lat;
                BlocProvider.of<CameraBloc>(context).add(CameraInitialized());
              }
            },
          ),
          BlocListener<PlantIdentBloc, PlantIdentState>(
              listener: (context, state) {
            if (state is PlantIdentLoadSuccess) {
              imageUrl = state.plant.imageUrl;
              AutoRouter.of(context)
                  .push(PlantDetailsRoute(
                      plant: state.plant
                          .copyWith(lon: lon, lat: lat, date: DateTime.now())))
                  .then((value) => {
                        if (value != null && value == true)
                          {
                            BlocProvider.of<PlantHistoryBloc>(context).add(
                                PlantHistoryRequested(
                                    plant: state.plant.copyWith(
                                        lon: lon,
                                        lat: lat,
                                        date: DateTime.now(),
                                        imageUrl: imageUrl))),
                            BlocProvider.of<CameraBloc>(context)
                                .add(CameraInitialized())
                          }
                        else if (value != null)
                          {
                            BlocProvider.of<PlantIdentBloc>(context)
                                .add(const PlantBotanicIdentInitial()),
                          }
                      });
            }
            if (state is PlantSecondIdentInitial) {
              final Plant plant = Plant(
                  imageUrl: imageUrl!,
                  date: DateTime.now(),
                  lat: lat,
                  lon: lon);
              BlocProvider.of<PlantIdentBloc>(context)
                  .add(PlantBotanicIdentRequested(plant));
              BlocProvider.of<PlantHistoryBloc>(context)
                  .add(PlantHistoryRequested(plant: plant));
              BlocProvider.of<CameraBloc>(context).add(CameraInitialized());
            }
            if (state is PlantIdentLimitReached) {
              _showNotification(context);
              BlocProvider.of<CameraBloc>(context).add(CameraInitialized());
            }
          }),
        ],
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(children: [
            BlocBuilder<CameraBloc, CameraState>(
              builder: (context, state) {
                if (state is CameraLoadInProcess ||
                    state is CameraPhotoLoadInProgress) {
                  return Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is CameraLoadSuccess) {
                  return CameraPreview(state.controller);
                }
                if (state is PhotoLoadedSuccess) {
                  BlocProvider.of<PlantIdentBloc>(context)
                      .add(PlantIdentRequested(state.imagePath));
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Image.file(File(state.imagePath)),
                    ),
                  );
                }
                if (state is CameraLoadFailure) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                        child: Text(
                      cameraNotAvailable,
                      style: Theme.of(context).textTheme.titleSmall,
                    )),
                  );
                }
                return Container(
                  color: Colors.black,
                  child: Center(
                      child: Text(
                    cameraNotAvailable,
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
                        "Фото, сделанное через приложение, будет видно другим пользователям",
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
                BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
                  return Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<CameraBloc>(context)
                            .add(CameraCaptured());
                      },
                      child:
                          const CircleButton(icon: Icons.camera_alt_outlined),
                    ),
                  );
                }),
                Expanded(
                  flex: 1,
                  child: BlocBuilder<PlantIdentBloc, PlantIdentState>(
                      builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        BlocProvider.of<CameraBloc>(context)
                            .add(GalleryLoaded());
                      },
                      child: const CircleButton(icon: Icons.photo),
                    );
                  }),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Future<bool?> _showNotification(context) async => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Advertisement();
        },
      );
}
