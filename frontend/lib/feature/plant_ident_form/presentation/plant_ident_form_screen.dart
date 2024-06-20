import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/domain/models/models.dart';
import '../../../core/presentation/widgets/plant_tile.dart';
import 'bloc/ident.dart';
import 'widgets/plant_ident_form.dart';

@RoutePage()
class PlantIdentFormScreen extends StatelessWidget {
  const PlantIdentFormScreen({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => IdentBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
                top: 40, bottom:16,
                left:16, right:16),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Image border
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(File(plant.imageUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: Icon(Icons.camera_alt, size: height * 0.1,),
                            );
                          },
                        ),
                        OverflowBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.arrow_back_ios),
                              iconSize: 24,
                              onPressed: () {
                                AutoRouter.of(context).back();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(plant.name,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: height * 0.02,),
                    PlantTile(
                      titleText: plant.lon != null && plant.lat != null
                          ? "lon: ${plant.lon} lat: ${plant.lat}"
                          : "Местоположение неизвестно",
                      icon: Iconsax.location,
                    ),
                    PlantTile(
                      titleText: plant.date != null
                          ? plant.date!.day.toString()
                          : "Дата неизвестна",
                      icon: Icons.timer_rounded,
                    ),
                    SizedBox(height: height * 0.03,),
                  ],
                ),
                PlantIdentForm(plant: plant,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
