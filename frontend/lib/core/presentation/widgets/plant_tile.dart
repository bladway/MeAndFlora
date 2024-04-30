import 'package:flutter/material.dart';

class PlantTile extends StatelessWidget {
  const PlantTile({super.key, required this.titleText, required this.icon});

  final String titleText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 5,
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: SizedBox(
        width: 20,
        child: Icon(
          icon,
          color: Colors.white, size: 18,
        ),
      ),
      title: Text(titleText,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
