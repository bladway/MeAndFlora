import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/feature/statistic/presentation/widgets/statistic_table.dart';

import '../../../core/presentation/widgets/notifications/app_notification.dart';
import '../../../core/theme/theme.dart';
import 'bloc/statistic.dart';
import 'widgets/calendar.dart';

@RoutePage()
class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  List<DateTime?> startDate = [
    DateTime.now(),
  ];
  List<DateTime?> endDate = [
    DateTime.now(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => StatisticBloc(),
      child: BlocListener<StatisticBloc, StatisticState>(
        listener: (BuildContext context, StatisticState state) {
          if (state is StatisticLoadFailture) {
            _showNotification();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Text(
              'Статистика приложения',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Calendar(
                  text: "Начало отсчета:", func: changeStartDate,
                ),
                Calendar(
                  text: "Окончание отсчета:", func: changeEndDate,
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<StatisticBloc, StatisticState>(
                    builder: (context, state) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [colors.lightGreen, colors.blueGreen])),
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<StatisticBloc>(context).add(
                              StatisticIdentRequested(
                                  startDate: startDate.first,
                                  endDate: endDate.first));
                        },
                        child: Text(
                          "Показать статистику распознавания",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<StatisticBloc, StatisticState>(
                    builder: (context, state) {
                      if (state is StatisticIdentLoadSuccess) {
                        return StatisticTable(map: state.map,);
                      }
                      return Container();
                    }),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<StatisticBloc, StatisticState>(
                    builder: (context, state) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [colors.lightGreen, colors.blueGreen])),
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<StatisticBloc>(context).add(
                              StatisticAdWatchRequested(
                                  startDate: startDate.first,
                                  endDate: endDate.first));
                        },
                        child: Text(
                          "Показать статистику просмотра рекламы",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<StatisticBloc, StatisticState>(
                    builder: (context, state) {
                  if (state is StatisticAdWatchLoadSuccess) {
                    return StatisticTable(map: state.map,);
                  }
                  return Container();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  changeStartDate(List<DateTime?> newDate) {
    setState(() {
      startDate = newDate;
    });
  }

  changeEndDate(List<DateTime?> newDate) {
    setState(() {
      endDate = newDate;
    });
  }

  Future<void> _showNotification() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AppNotification(
          text: 'Введенные данные некорректны.',
        );
      },
    );
  }
}
