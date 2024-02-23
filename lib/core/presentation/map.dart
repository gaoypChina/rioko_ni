import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';

class MapBuilder {
  Widget build() {
    return const Map();
  }
}

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 33, 70, 54),
      child: _buildMap(context),
    );
  }

  Widget _buildMap(BuildContext context) {
    return InteractiveViewer(
      maxScale: 20,
      minScale: 4,
      transformationController: TransformationController(
        Matrix4.diagonal3Values(4, 4, 1)
          ..translate(-MediaQuery.of(context).size.width / 2.5,
              -MediaQuery.of(context).size.height * 0.37),
      ),
      boundaryMargin: EdgeInsets.zero,
      child: SimpleMap(
        countryBorder: const CountryBorder(
            color: Color.fromARGB(255, 92, 195, 135), width: 0.5),
        instructions: SMapWorld.instructionsMercator,
        callback: (id, name, tabDetails) {
          print(id + name);
        },
        defaultColor: Colors.black,
      ),
    );
  }
}
