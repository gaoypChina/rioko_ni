import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geobase/geobase.dart';
import 'package:rioko_ni/core/errors/exception.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/models/country_polygons_model.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class MapLocalDataSourceImpl implements MapLocalDataSource {
  const MapLocalDataSourceImpl();

  static String get countriesPath => 'assets/geo/countries.json';

  @override
  Future<CountryPolygonsModel> getCountryPolygons({
    required String countryCode,
  }) async {
    try {
      final countriesData = await rootBundle.loadString(countriesPath);
      final data = jsonDecode(countriesData) as Map<String, dynamic>;
      final featureCollection = FeatureCollection.fromData(data);
      final countryFeature = featureCollection.features.firstWhereOrNull(
          (feature) => feature.properties["ISO_A3"] == countryCode);
      if (countryFeature == null) {
        throw const CacheException(
            'Could not find a country for provided code');
      }
      return CountryPolygonsModel(
        countryCode: countryCode,
        featureCollection: FeatureCollection([countryFeature]),
      );
    } on ServerException {
      rethrow;
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }
}
