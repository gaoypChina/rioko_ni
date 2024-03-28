import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geobase/geobase.dart';
import 'package:rioko_ni/core/errors/exception.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/models/country_model.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapLocalDataSourceImpl implements MapLocalDataSource {
  final SharedPreferences sharedPreferences;
  const MapLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  static String get countriesGeoDataPath => 'assets/data/geo/countries.json';
  static String get regionsDataPath => 'assets/data/regions.json';

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final countriesGeoData =
          await rootBundle.loadString(countriesGeoDataPath);
      final regionsData = await rootBundle.loadString(regionsDataPath);
      final geoData = jsonDecode(countriesGeoData) as Map<String, dynamic>;
      final regions = Map<String, List<dynamic>>.from(jsonDecode(regionsData));
      final featureCollection = FeatureCollection.fromData(geoData);
      return featureCollection.features
          .where((feature) => feature.properties["ISO_A3"] != "-99")
          .map((feature) {
        final cca3 = feature.properties["ISO_A3"];
        final regionName = regions.keys.firstWhere(
          (key) => regions[key]!.cast<String>().contains(cca3),
        );
        return CountryModel(
          countryCode: cca3,
          featureCollection: FeatureCollection([feature]),
          region: RegionExtension.fromString(regionName),
        );
      }).toList();
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
        'been',
        params.beenCodes,
      );
      await sharedPreferences.setStringList(
        'want',
        params.wantCodes,
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

      return ManageCountriesLocallyParams(
        beenCodes: beenCodes ?? [],
        wantCodes: wantCodes ?? [],
      );
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }
}
