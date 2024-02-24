import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/core/presentation/map.dart';
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
        onPressed: _cubit.displayPolygons,
        backgroundColor: const Color.fromARGB(255, 50, 168, 109),
        child: const Icon(Icons.polyline),
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
