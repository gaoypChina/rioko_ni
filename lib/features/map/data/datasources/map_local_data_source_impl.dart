import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geobase/geobase.dart';
import 'package:rioko_ni/core/errors/exception.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/models/country_model.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapLocalDataSourceImpl implements MapLocalDataSource {
  final SharedPreferences sharedPreferences;
  const MapLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  static String get countriesGeoDataPath => 'assets/data/geo/countries.json';
  static String get countriesInfoDataPath => 'assets/data/countries_info.json';

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final countriesGeoData =
          await rootBundle.loadString(countriesGeoDataPath);
      final countriesInfoData =
          await rootBundle.loadString(countriesInfoDataPath);
      final geoData = jsonDecode(countriesGeoData) as Map<String, dynamic>;
      final infoData =
          List<Map<String, dynamic>>.from(jsonDecode(countriesInfoData));
      final featureCollection = FeatureCollection.fromData(geoData);
      return featureCollection.features
          .where((feature) => feature.properties["ISO_A3"] != "-99")
          .map((feature) {
        final cca3 = feature.properties["ISO_A3"];
        final info = infoData.firstWhere((e) => e["cca3"] == cca3);
        return CountryModel(
          countryCode: cca3,
          featureCollection: FeatureCollection([feature]),
          region: info["region"] ?? '',
          subregion: info["subregion"] ?? '',
          name: info["name"] ?? '',
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
