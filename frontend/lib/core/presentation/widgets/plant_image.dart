import 'dart:io';

import 'package:flutter/material.dart';
import 'package:me_and_flora/core/domain/api/api_key.dart';

import '../../theme/theme.dart';

class PlantImage extends StatelessWidget {
  const PlantImage({super.key, required this.image, required this.size});
  final String image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '$baseUrl/file/byPath?imagePath=${image.replaceAll("/", "%2F")}',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: colors.lightGray,
          alignment: Alignment.center,
          child: Icon(
            Icons.photo_camera,
            size: size,
          ),
        );
      },
    );
  }
}
