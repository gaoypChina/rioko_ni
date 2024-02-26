import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geobase/geobase.dart';
import 'package:rioko_ni/core/errors/exception.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/models/country_polygons_model.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapLocalDataSourceImpl implements MapLocalDataSource {
  final SharedPreferences sharedPreferences;
  const MapLocalDataSourceImpl({
    required this.sharedPreferences,
  });

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

  @override
  Future<void> saveCountriesLocally({
    required ManageCountriesLocallyParams params,
  }) async {
    try {
      await sharedPreferences.setStringList(
        params.type!.name,
        params.beenCodes,
      );
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }

  @override
  Future<ManageCountriesLocallyParams> readCountriesLocally() async {
    try {
      final beenCodes = sharedPreferences.getStringList('been');
      final wantCodes = sharedPreferences.getStringList('want');

      return ManageCountriesLocallyParams.read(
        beenCodes: beenCodes ?? [],
        wantCodes: wantCodes ?? [],
      );
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }
}
