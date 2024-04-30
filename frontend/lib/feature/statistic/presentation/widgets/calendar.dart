import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.text, required this.func});
  final String text;
  final Function func;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<DateTime?> date = [DateTime.now(),];

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: colors.blueGreen,
      weekdayLabels: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
      weekdayLabelTextStyle: Theme.of(context)
          .textTheme
          .labelLarge
          ?.merge(TextStyle(color: colors.lightGreen)),
      yearTextStyle: Theme.of(context).textTheme.labelMedium,
      firstDayOfWeek: 1,
      controlsTextStyle: Theme.of(context).textTheme.labelMedium,
      dayTextStyle: Theme.of(context).textTheme.bodyMedium,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              "${widget.text} ",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              _getValueText(
                config.calendarType,
                date,
              ),
            ),
          ],
        ),
        CalendarDatePicker2(
          config: config,
          value: date,
          onValueChanged: (value) {
            setState(() {
              date = value;
            });
            widget.func(value);
          }
        ),
      ],
    );
  }

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');
    return valueText;
  }
}
