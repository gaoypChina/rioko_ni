import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/map.dart';
import 'package:rioko_ni/core/presentation/widgets/animated_fab.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:rioko_ni/features/map/presentation/widgets/search_country_dialog.dart';
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

  bool showWorldStatistics = false;

  late MapController mapController;

  @override
  void initState() {
    mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

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
              title: Text(tr('core.errorMessageTitle')),
              description: Text(message),
              autoCloseDuration: const Duration(seconds: 5),
              alignment: Alignment.topCenter,
            ),
            setCurrentPosition: (position) =>
                mapController.move(position, mapController.camera.zoom),
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return Stack(
                children: [
                  WorldStatisticsMap(
                    naPercentage: showWorldStatistics
                        ? _cubit.beenNorthAmericaPercentage
                        : 0,
                    saPercentage: showWorldStatistics
                        ? _cubit.beenSouthAmericaPercentage
                        : 0,
                    euPercentage:
                        showWorldStatistics ? _cubit.beenEuropePercentage : 0,
                    afPercentage:
                        showWorldStatistics ? _cubit.beenAfricaPercentage : 0,
                    asPercentage:
                        showWorldStatistics ? _cubit.beenAsiaPercentage : 0,
                    ocPercentage:
                        showWorldStatistics ? _cubit.beenOceaniaPercentage : 0,
                    onTapShare: () => Future.delayed(
                        const Duration(milliseconds: 200),
                        () => _closeTopDrawer()),
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
                    been: _cubit.beenCountries.length,
                    want: _cubit.wantCountries.length,
                    lived: _cubit.livedCountries.length,
                    toggleTopBehindDrawer: () async {
                      showTopBehindDrawer = !showTopBehindDrawer;
                      setState(() {});
                      if (!showTopBehindDrawer) {
                        await Future.delayed(const Duration(milliseconds: 500));
                      }
                      showWorldStatistics = showTopBehindDrawer;
                      setState(() {});
                    },
                    lowerTopUI: showTopBehindDrawer,
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedFAB(
        onPressed: () {
          _closeTopDrawer();
          showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              return Opacity(
                opacity: a1.value,
                child: widget,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation1, animation2) =>
                const SearchCountryDialog(),
          );
        },
        icon: const FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return MapBuilder().build(
      context,
      urlTemplate: _cubit.urlTemplate,
      beenCountries: _cubit.beenCountries,
      wantCountries: _cubit.wantCountries,
      livedCountries: _cubit.livedCountries,
      controller: mapController,
      onTap: (position, latLng) => _closeTopDrawer(),
      dir: _cubit.dir,
    );
  }

  void _closeTopDrawer() {
    if (showTopBehindDrawer == false) return;
    showTopBehindDrawer = false;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      showWorldStatistics = showTopBehindDrawer;
      setState(() {});
    });
  }
}
