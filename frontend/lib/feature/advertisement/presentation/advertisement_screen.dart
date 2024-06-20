import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/feature/advertisement/presentation/bloc/advertisement_bloc.dart';
import 'package:me_and_flora/feature/advertisement/presentation/bloc/advertisement_event.dart';
import 'package:me_and_flora/feature/advertisement/presentation/bloc/advertisement_state.dart';

import '../../../core/presentation/widgets/buttons/circle_button.dart';

@RoutePage()
class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppMetrica.reportEvent('Просмотр рекламы');

    return BlocProvider<AdvertisementBloc>(
      lazy: false,
      create: (_) => AdvertisementBloc()..add(AdvertisementInitialized()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    AutoRouter.of(context).pop();
                  },
                  child: const CircleButton(icon: Icons.close),
                )),
          ],
        ),
        body: BlocBuilder<AdvertisementBloc, AdvertisementState>(
          builder: (context, state) {
            if (state is AdvertisementSuccess) {
              return Center(
                  child: Text(
                    'Место для вашей рекламы',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge,
                  ));
            }
            return const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
