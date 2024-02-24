import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geobase/geobase.dart';
import 'package:rioko_ni/core/errors/exception.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/models/country_polygons_model.dart';

class MapLocalDataSourceImpl implements MapLocalDataSource {
  const MapLocalDataSourceImpl();

  static String get countriesPath => 'assets/geo/countries.json';

  @override
  Future<List<CountryPolygonsModel>> getCountryPolygons() async {
    try {
      final countriesData = await rootBundle.loadString(countriesPath);
      final data = jsonDecode(countriesData) as Map<String, dynamic>;
      final featureCollection = FeatureCollection.fromData(data);
      return featureCollection.features
          .map((feature) => CountryPolygonsModel(
                countryCode: feature.properties["ISO_A3"],
                featureCollection: FeatureCollection([feature]),
              ))
          .toList();
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }
}
