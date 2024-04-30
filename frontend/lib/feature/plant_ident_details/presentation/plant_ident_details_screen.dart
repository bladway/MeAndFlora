import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:me_and_flora/core/presentation/widgets/buttons/track_button.dart';
import 'package:me_and_flora/core/presentation/widgets/plant_image.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../../../core/domain/models/models.dart';
import '../../../core/presentation/bloc/plant_track/plant_track.dart';
import 'widgets/ident_work_request.dart';
import 'widgets/plant_description.dart';
import '../../../core/presentation/widgets/widgets.dart';

@RoutePage()
class PlantIdentDetailsScreen extends StatelessWidget {
  const PlantIdentDetailsScreen({super.key, required this.plant, required this.imageUrl});

  final Plant plant;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double padding = 16;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: padding),
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 24,
            onPressed: () async {
              AppMetrica.reportEvent(
                  'Переход на страницу распознанного растения');
              bool? isCorrectIdent = await _showNotification(context, plant);
              AutoRouter.of(context).pop(isCorrectIdent ?? true);
            },
          ),
        ),
        actions: [
          BlocBuilder<PlantTrackBloc, PlantTrackState>(
              builder: (context, state) {
            return Padding(
                padding: EdgeInsets.only(right: padding),
                child: TrackButton(
                  plant: plant,
                  size: 24,
                ));
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: padding,
              left: padding,
              right: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.45,
                width: width,
                child: Stack(
                  children: [
                    SizedBox(
                      height: height * 0.35,
                      width: width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: PlantImage(
                          image: plant.imageUrl,
                          size: height * 0.1,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(2), // Border width
                        decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: height * 0.175,
                            width: width * 0.5,
                            child: PlantImage(
                              image: imageUrl,
                              size: height * 0.0175,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.07,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    plant.name,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  PlantTile(
                    titleText: plant.lon != null && plant.lat != null
                        ? "${plant.lon}°, ${plant.lat}°"
                        : "Местоположение неизвестно",
                    icon: Iconsax.location,
                  ),
                  PlantTile(
                    titleText: plant.date != null
                        ? plant.date.toString().substring(0, 10)
                        : "Дата неизвестна",
                    icon: Icons.timer_rounded,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  //PlantDescription(desc: plant.description),
                ],
              ),
              PlantDescription(desc: plant.description),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showNotification(context, Plant plant) async => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return IdentWorkRequest(plant: plant);
        },
      );
}
