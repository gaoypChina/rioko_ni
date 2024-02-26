import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/map.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:rioko_ni/features/map/presentation/widgets/stats_ui.dart';
import 'package:toastification/toastification.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _cubit = locator<MapCubit>();

  bool showTopBehindDrawer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.only(
                  top: AppSizes.paddingQuintuple,
                  bottom: AppSizes.paddingQuadruple,
                  left: AppSizes.paddingSextuple,
                  right: AppSizes.paddingQuadruple,
                ),
                child: const SimpleMap(
                  instructions: SMapWorld.instructionsMercator,
                  defaultColor: Colors.black,
                  countryBorder: CountryBorder(color: Colors.tealAccent),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastEaseInToSlowEaseOut,
                margin: EdgeInsets.only(
                  top: showTopBehindDrawer
                      ? MediaQuery.of(context).size.height * 0.3
                      : 0,
                ),
                child: _buildMap(context),
              ),
              StatsUI(
                been: _cubit.beenCountryPolygons.length,
                want: _cubit.wantCountryPolygons.length,
                notWant: 0,
                toggleTopBehindDrawer: () =>
                    setState(() => showTopBehindDrawer = !showTopBehindDrawer),
                lowerTopUI: showTopBehindDrawer,
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
