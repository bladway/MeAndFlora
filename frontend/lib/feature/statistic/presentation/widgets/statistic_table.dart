import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class StatisticTable extends StatelessWidget {
  const StatisticTable({super.key, required this.map});

  final Map map;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [colors.lightGreen, colors.blueGreen])),
            children: const [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Дата",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Кол-во операций",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]),
        ...map.entries
            .map((e) => TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        e.key.toString().replaceAll('00:00:00.000', ''),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        e.value.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]))
            .toList(),
      ],
    );
  }
}
