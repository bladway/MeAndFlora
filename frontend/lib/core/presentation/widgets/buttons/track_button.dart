import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:me_and_flora/core/presentation/bloc/plant_track/plant_track.dart';

import '../../../domain/models/models.dart';
import '../../../theme/strings.dart';
import '../../bloc/auth/auth.dart';
import '../notifications/app_notification.dart';

class TrackButton extends StatelessWidget {
  const TrackButton({super.key, required this.plant, required this.size});

  final Plant plant;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthenticatedState &&
          state.account.role != AccessLevel.botanist &&
          state.account.role != AccessLevel.admin) {
        return IconButton(
          icon: Icon(
            plant.subscribed ? Iconsax.location : Iconsax.location_copy,
            size: size,
            color: Colors.white,
          ),
          onPressed: () {
            if (state.account.role != AccessLevel.unauth_user) {
              plant.subscribed = !plant.subscribed;
              BlocProvider.of<PlantTrackBloc>(context)
                  .add(PlantTrackRequested(plant.name));
            } else {
              _showTrackNotification(context);
            }
          },
        );
      } else {
        return const Center();
      }
    });
  }

  Future<void> _showTrackNotification(context) async => showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AppNotification(
            text: trackNotification,
          );
        },
      );
}
