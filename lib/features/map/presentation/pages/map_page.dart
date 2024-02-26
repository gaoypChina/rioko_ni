import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/map.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:rioko_ni/features/map/presentation/widgets/stats_ui.dart';
import 'package:rioko_ni/features/map/presentation/widgets/world_statistics_map.dart';
import 'package:toastification/toastification.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _cubit = locator<MapCubit>();

  bool showTopBehindDrawer = false;

  bool showPercentages = false;

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
              WorldStatisticsMap(
                northAmericaPercentage:
                    showPercentages ? _cubit.northAmericaPercentage : 0,
                southAmericaPercentage:
                    showPercentages ? _cubit.southAmericaPercentage : 0,
                europePercentage: showPercentages ? _cubit.europePercentage : 0,
                africaPercentage: showPercentages ? _cubit.africaPercentage : 0,
                asiaPercentage: showPercentages ? _cubit.asiaPercentage : 0,
                oceaniaPercentage:
                    showPercentages ? _cubit.oceaniaPercentage : 0,
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
                toggleTopBehindDrawer: () async {
                  showTopBehindDrawer = !showTopBehindDrawer;
                  setState(() {});
                  if (!showTopBehindDrawer) {
                    await Future.delayed(const Duration(milliseconds: 500));
                  }
                  showPercentages = showTopBehindDrawer;
                  setState(() {});
                },
                lowerTopUI: showTopBehindDrawer,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _cubit.saveCountriesLocally(
            beenCountries: [
              ..._cubit.countriesGeoData.getRange(10, 50),
              ..._cubit.countriesGeoData.getRange(110, 150),
            ],
            wantCountries: [
              ..._cubit.countriesGeoData.getRange(51, 110),
              ..._cubit.countriesGeoData.getRange(151, 210),
            ],
          );
        },
        child: Icon(Icons.abc_outlined),
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
