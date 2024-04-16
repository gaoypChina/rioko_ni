import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/map.dart';
import 'package:rioko_ni/core/presentation/widgets/animated_fab.dart';
import 'package:rioko_ni/core/presentation/widgets/rioko_drawer.dart';
import 'package:rioko_ni/core/presentation/widgets/toast.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';
import 'package:rioko_ni/features/map/presentation/widgets/country_management_dialog.dart';
import 'package:rioko_ni/features/map/presentation/widgets/search_country_dialog.dart';
import 'package:rioko_ni/features/map/presentation/widgets/floating_ui.dart';
import 'package:rioko_ni/features/map/presentation/widgets/world_statistics_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _mapCubit = locator<MapCubit>();

  bool showTopBehindDrawer = false;

  bool showWorldStatistics = false;

  late MapController mapController;

  Key _mapKey = UniqueKey();
  Key _polygonsLayerKey = UniqueKey();

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
      drawer: RiokoDrawer(
        showWorldStatistics: showWorldStatistics,
        openTopBehindDrawer: () {
          showTopBehindDrawer = true;
          showWorldStatistics = true;
          setState(() {});
        },
        updateMap: () => setState(() {
          _mapKey = UniqueKey();
          _polygonsLayerKey = UniqueKey();
        }),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) => ToastBuilder(message: message).show(context),
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
                        ? _mapCubit.beenNorthAmericaPercentage
                        : 0,
                    saPercentage: showWorldStatistics
                        ? _mapCubit.beenSouthAmericaPercentage
                        : 0,
                    euPercentage: showWorldStatistics
                        ? _mapCubit.beenEuropePercentage
                        : 0,
                    afPercentage: showWorldStatistics
                        ? _mapCubit.beenAfricaPercentage
                        : 0,
                    asPercentage:
                        showWorldStatistics ? _mapCubit.beenAsiaPercentage : 0,
                    ocPercentage: showWorldStatistics
                        ? _mapCubit.beenOceaniaPercentage
                        : 0,
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
                  FloatingUI(
                    lowerTopUI: showTopBehindDrawer,
                    openTopBehindDrawer: () {
                      if (showTopBehindDrawer) return _closeTopDrawer();
                      _showTopDrawer();
                    },
                    openDrawer: () {
                      _closeTopDrawer();
                      Scaffold.of(context).openDrawer();
                    },
                    onDragDown: _showTopDrawer,
                    onDragUp: _closeTopDrawer,
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
                SearchCountryDialog(
              onSelectCountry: (country) {
                mapController
                    .fitCamera(CameraFit.bounds(bounds: country.bounds));
                mapController.move(
                    mapController.camera.center, mapController.camera.zoom - 2);
                debugPrint(country.alpha3);
              },
              fetchRegions: _mapCubit.getCountryRegions,
            ),
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
      key: _mapKey,
      polygonsLayerKey: _polygonsLayerKey,
      urlTemplate: _mapCubit.urlTemplate,
      beenCountries: _mapCubit.beenCountries,
      wantCountries: _mapCubit.wantCountries,
      livedCountries: _mapCubit.livedCountries,
      center: _mapCubit.currentPosition,
      controller: mapController,
      onTap: (position, latLng) {
        if (showTopBehindDrawer) {
          return _closeTopDrawer();
        }
        final country = _mapCubit.getCountryFromPosition(latLng);
        if (country == null) return;
        CountryManagementDialog(
          country: country,
          fetchRegions: _mapCubit.getCountryRegions,
        ).show(context);
      },
      dir: _mapCubit.dir,
      regions: _mapCubit.fetchedRegions,
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

  void _showTopDrawer() {
    showTopBehindDrawer = true;
    showWorldStatistics = true;
    setState(() {});
  }
}
