import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/presentation/widgets/background.dart';
import 'package:me_and_flora/core/presentation/widgets/notifications/app_notification.dart';
import 'package:me_and_flora/core/theme/strings.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../../../core/app_router/app_router.dart';
import '../../../core/domain/models/models.dart';
import '../../../core/presentation/bloc/plant/plant.dart';
import '../../../core/presentation/bloc/plant_search/plant_search.dart';
import '../../../core/presentation/widgets/plant_list.dart';
import '../../../core/presentation/widgets/search_delegate.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlantSearchBloc, PlantSearchState>(
      listener: (BuildContext context, PlantSearchState state) {
        if (state is PlantSearchLoadSuccess) {
          AppMetrica.reportEvent(
              'Переход на страницу найденного по названию растения');
          AutoRouter.of(context).push(PlantDetailsRoute(
              plant: Plant(
                  name: state.plant.name,
                  type: state.plant.type,
                  description: state.plant.description,
                  subscribed: state.plant.subscribed,
                  path: state.plant.path)));
        } else if (state is PlantSearchLoadFailure) {
          _showNotification(context);
        }
      },
      child: Stack(children: [
        const Background(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 90, bottom: 70),
                    child: BlocBuilder<PlantSearchBloc, PlantSearchState>(
                        builder: (context, state) {
                      return TextField(
                        style: Theme.of(context).textTheme.bodySmall,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: search,
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 24,
                            weight: 3,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          AppMetrica.reportEvent(
                              'Переход на страницу поиска по названию');
                          showSearch(
                              context: context,
                              delegate: MySearchDelegate((query) =>
                                  BlocProvider.of<PlantSearchBloc>(context)
                                    ..add(PlantSearchRequested(query))));
                        },
                      );
                    }),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return PlantList(
                        type: PlantType.values[i],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 24,
                      );
                    },
                    itemCount: PlantType.values.length - 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _showNotification(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AppNotification(text: plantNotFoundNotification);
      },
    );
  }
}
