import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../../domain/models/models.dart';

class PlantElement extends StatefulWidget {
  const PlantElement({super.key, required this.plant});

  final Plant plant;

  @override
  State<PlantElement> createState() => _PlantElementState();
}

class _PlantElementState extends State<PlantElement> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      width: width * 0.42,
      decoration: BoxDecoration(
          color: colors.gray,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: InkWell(
        onTap: () {
          AutoRouter.of(context).push(PlantDetailsRoute(plant: widget.plant));
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  height: height * 0.1,
                  width: width * 0.39,
                  padding: const EdgeInsets.only(top: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.plant.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: colors.lightGray,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.photo_camera,
                                size: 35,
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              widget.plant.isTracked
                                  ? Iconsax.location
                                  : Iconsax.location_copy,
                              size: height * 0.1 * width * 0.39 * 0.0019,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.plant.name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        widget.plant.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400, //Regular
                          color: colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}