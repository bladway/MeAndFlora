import 'package:flutter/material.dart';

class PlantDescription extends StatefulWidget {
  const PlantDescription({super.key, required this.desc});

  final String desc;

  @override
  State<PlantDescription> createState() => _PlantDescriptionState(desc, false);
}

class _PlantDescriptionState extends State<PlantDescription> {

  final String desc;
  bool isOpenText;

  _PlantDescriptionState(this.desc, this.isOpenText);

  void _tapReadMore() => isOpenText = !isOpenText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isOpenText
            ? Text(desc,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.labelMedium,
          softWrap: true,
        )
            : Text(
          desc,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.labelMedium,
          softWrap: true,
          maxLines: 8,
          overflow: TextOverflow.ellipsis,
        ),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.zero),
          ),
          onPressed: () {
            setState(() {
              _tapReadMore();
            });
          },
          child: Text(isOpenText ? 'Свернуть' : 'Развернуть',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
