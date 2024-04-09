import 'dart:convert';
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
  static String get countriesDataPath => 'assets/data/countries.json';
  static String get areasDataPath => 'assets/data/areas.json';

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final countriesGeoData =
          await rootBundle.loadString(countriesGeoDataPath);
      final areasData = await rootBundle.loadString(areasDataPath);
      final countriesInfoData = await rootBundle.loadString(countriesDataPath);
      final geoData = jsonDecode(countriesGeoData) as Map<String, dynamic>;
      final infoData = jsonDecode(countriesInfoData) as Map<String, dynamic>;
      final areas = Map<String, List<dynamic>>.from(jsonDecode(areasData));
      final List<CountryModel> result = [];
      for (String key in geoData.keys) {
        final cca3 = key;
        final info = infoData[cca3] as Map<String, dynamic>;
        final List<List<List<double>>> polygons = (geoData[key]
                as List<dynamic>)
            .map<List<List<double>>>((dynamic item) => (item as List<dynamic>)
                .map<List<double>>((dynamic innerItem) =>
                    (innerItem as List<dynamic>)
                        .map<double>((dynamic subItem) => subItem.toDouble())
                        .toList())
                .toList())
            .toList();
        final area = areas[info['area']] as String;
        result.add(CountryModel(
          polygons: polygons,
          countryCode: cca3,
          region: AreaExtension.fromString(area),
          moreDataAvailable: info['more_data_available'] as bool,
        ));
      }
      return result;
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }
}
