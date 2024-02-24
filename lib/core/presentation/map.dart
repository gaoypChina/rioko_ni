import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rioko_ni/core/extensions/iterable2.dart';
import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';

class MapBuilder {
  MapOptions getMapOptions({
    double? initialZoom,
    double? minZoom,
    double? maxZoom,
    Color? backgroundColor,
    InteractionOptions? interactionOptions,
  }) {
    return MapOptions(
      interactionOptions: interactionOptions,
      initialZoom: initialZoom ?? 5,
      backgroundColor: backgroundColor ?? const Color(0x00000000),
      // Smallest possible number. For values of 2 and less, the polygons displayed on the map bug out -
      // this is due to the fact that polygons for maximum longitude and minimum longitude are visible at the same time,
      // and flutter_map incorrectly analyzes them and tries to merge them together.
      minZoom: minZoom ?? 3,
      maxZoom: maxZoom ?? 17,
    );
  }

  Widget build(
    BuildContext context, {
    required String urlTemplate,
    required List<CountryPolygons> beenCountries,
    required List<CountryPolygons> wantCountries,
  }) {
    final mapOptions = getMapOptions(
      interactionOptions: const InteractionOptions(
        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
      ),
    );
    List<Widget> layers = [];
    layers.add(
      TileLayer(
        retinaMode: RetinaMode.isHighDensity(context),
        urlTemplate: urlTemplate,
        additionalOptions: const {
          "accessToken": String.fromEnvironment("map_box_access_token"),
        },
      ),
    );
    layers.add(
      PolygonLayer(
        polygonCulling: true,
        polygons: [
          ...Iterable2(beenCountries.map((country) => country.polygons(
                        borderColor: Colors.tealAccent,
                      )))
                  .reduceOrNull((value, element) => [...value, ...element]) ??
              [],
          ...Iterable2(wantCountries.map((country) => country.polygons(
                        borderColor: Colors.purpleAccent,
                      )))
                  .reduceOrNull((value, element) => [...value, ...element]) ??
              [],
        ],
      ),
    );
    return Map(
      mapOptions: mapOptions,
      layers: layers,
    );
  }
}

class Map extends StatelessWidget {
  final MapOptions mapOptions;
  final List<Widget> layers;
  const Map({
    required this.mapOptions,
    required this.layers,
    super.key,
  });

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
    return FlutterMap(
      options: mapOptions,
      children: layers,
    );
  }
}
