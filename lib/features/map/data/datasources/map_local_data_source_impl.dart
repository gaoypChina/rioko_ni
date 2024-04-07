import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rioko_ni/core/errors/exception.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/models/country_model.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapLocalDataSourceImpl implements MapLocalDataSource {
  final SharedPreferences sharedPreferences;
  const MapLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  static String get countriesGeoDataPath =>
      'assets/data/geo/countries_geo.json';
  static String get regionsDataPath => 'assets/data/regions.json';

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final countriesGeoData =
          await rootBundle.loadString(countriesGeoDataPath);
      final regionsData = await rootBundle.loadString(regionsDataPath);
      final geoData = jsonDecode(countriesGeoData) as Map<String, dynamic>;
      final regions = Map<String, List<dynamic>>.from(jsonDecode(regionsData));
      final List<CountryModel> result = [];
      for (String key in geoData.keys) {
        final cca3 = key;
        final polygons =
            (geoData[key] as List<dynamic>).cast<List<List<double>>>();
        final region = regions.keys.firstWhere(
          (key) {
            debugPrint(cca3);
            return regions[key]!.cast<String>().contains(cca3);
          },
        );
        result.add(CountryModel(
          polygons: polygons,
          countryCode: cca3,
          region: RegionExtension.fromString(region),
        ));
      }
      return result;
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }
}
