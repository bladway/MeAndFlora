import 'package:flutter/material.dart';

import '../../domain/models/models.dart';
import 'plant_element.dart';

class PlantList extends StatefulWidget {
  const PlantList({super.key,
    required this.plantList, required this.title});

  final List<Plant> plantList;
  final String title;

  @override
  State<PlantList> createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: height * 0.005,),
        SizedBox(
          height: height * 0.22,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.plantList.length,
            separatorBuilder: (BuildContext context, _) => SizedBox(width: width * 0.05,),
            itemBuilder: (context, i) {
              final plant = widget.plantList[i];
              return PlantElement(plant: plant,);
            },
          ),
        ),
      ],
    );
  }
}
