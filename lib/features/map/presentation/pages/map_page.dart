import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geobase/geobase.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key});

  final _cubit = locator<MapCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 70, 54),
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return _buildMap(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _cubit.getPolandPolygon(),
        backgroundColor: const Color.fromARGB(255, 50, 168, 109),
        child: const Icon(Icons.polyline),
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        initialZoom: 5,
        backgroundColor: Color(0x00000000),
        minZoom: 2,
        maxZoom: 17,
      ),
      children: [
        TileLayer(
          retinaMode: RetinaMode.isHighDensity(context),
          urlTemplate: _cubit.urlTemplate,
          additionalOptions: const {
            "accessToken": String.fromEnvironment("map_box_access_token"),
          },
        ),
        PolygonLayer(
          polygonCulling: true,
          polygons: _cubit.countryPolygons?.polygons ?? [],
        ),
      ],
    );
  }
}
