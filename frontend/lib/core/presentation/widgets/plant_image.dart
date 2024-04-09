import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../domain/models/models.dart';
import '../../theme/theme.dart';

class PlantImage extends StatelessWidget {
  const PlantImage({super.key, required this.plant, required this.iconSize});

  final Plant plant;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Container(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              plant.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: colors.lightGray,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.photo_camera,
                    size: iconSize,
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  plant.isTracked
                      ? Iconsax.location
                      : Iconsax.location_copy,
                  size: height * 0.1 * width * 0.39 * 0.0019,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
