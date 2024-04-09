import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:me_and_flora/core/presentation/widgets/plant_tile.dart';

import '../../../core/domain/models/models.dart';
import 'widgets/plant_description.dart';

@RoutePage()
class PlantDetailsScreen extends StatefulWidget {
  const PlantDetailsScreen({super.key, required this.plant});

  final Plant plant;

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
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
                //width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Image border
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(widget.plant.imageUrl,
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
                          IconButton(
                            icon: Icon(
                              widget.plant.isTracked
                                  ? Iconsax.location
                                  : Iconsax.location_copy,
                              size: 24,
                              color: Colors.white,
                            ),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.07,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.plant.name,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: height * 0.02,),
                  PlantTile(
                    titleText: widget.plant.lon != null && widget.plant.lat != null
                        ? "lon: ${widget.plant.lon} lat: ${widget.plant.lat}"
                        : "Местоположение неизвестно",
                    icon: Iconsax.location,
                  ),
                  PlantTile(
                    titleText: widget.plant.date != null
                        ? widget.plant.date!.day.toString()
                        : "Дата неизвестна",
                    icon: Icons.timer_rounded,
                  ),
                  SizedBox(height: height * 0.03,),
                  PlantDescription(desc: widget.plant.description),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
