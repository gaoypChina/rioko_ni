import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/map.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:rioko_ni/features/map/presentation/widgets/stats_ui.dart';
import 'package:toastification/toastification.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key});

  final _cubit = locator<MapCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 70, 54),
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) => toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.minimal,
              title: const Text('Error'),
              description: Text(message),
              autoCloseDuration: const Duration(seconds: 5),
              alignment: Alignment.topCenter,
            ),
            orElse: () {},
          );
        },
        builder: (context, state) {
          _cubit.getPointsNumber();
          return Stack(
            children: [
              _buildMap(context),
              StatsUI(
                been: _cubit.beenCountryPolygons.length,
                want: _cubit.wantCountryPolygons.length,
                notWant: 0,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return MapBuilder().build(
      context,
      urlTemplate: _cubit.urlTemplate,
      beenCountries: _cubit.beenCountryPolygons,
      wantCountries: _cubit.wantCountryPolygons,
    );
  }
}
