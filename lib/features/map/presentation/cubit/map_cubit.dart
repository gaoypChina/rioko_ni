import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rioko_ni/core/domain/usecase.dart';

import 'package:rioko_ni/features/map/domain/entities/country.dart';
import 'package:rioko_ni/features/map/domain/usecases/get_countries.dart';
import 'package:rioko_ni/features/map/domain/usecases/read_countries_locally.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';

part 'map_state.dart';
part 'map_cubit.freezed.dart';

enum Countries {
  been,
  want,
}

class MapCubit extends Cubit<MapState> {
  final GetCountries getCountryPolygonUsecase;
  final ReadCountriesLocally readCountriesLocallyUsecase;
  final SaveCountriesLocally saveCountriesLocallyUsecase;
  MapCubit({
    required this.getCountryPolygonUsecase,
    required this.readCountriesLocallyUsecase,
    required this.saveCountriesLocallyUsecase,
  }) : super(const MapState.initial());

  String get urlTemplate =>
      "https://api.mapbox.com/styles/v1/mister-lucifer/cls7n0t4g00zh01qsdc652wos/tiles/256/{z}/{x}/{y}{r}?access_token={accessToken}";

  List<Country> countries = [];

  Future getCountryPolygons() async {
    await getCountryPolygonUsecase.call(NoParams()).then(
          (result) => result.fold(
            (failure) => emit(MapState.error(failure.message)),
            (countryPolygons) {
              countries = countryPolygons;
              emit(MapState.fetchedCountryPolygons(countryPolygons));
            },
          ),
        );
  }

  List<Country> countriesByString(String text) {
    final result = countries
        .where((country) =>
            country.name.toLowerCase().contains(text.toLowerCase()) ||
            country.region.toLowerCase().contains(text.toLowerCase()))
        .toList();
    return result;
  }

  Future getLocalCountryData() async {
    debugPrint('start');
    await readCountriesLocallyUsecase.call(NoParams()).then(
          (result) => result.fold(
            (failure) => MapState.error(failure.message),
            (data) {
              final beenCountries = countries
                  .where((c) => data.beenCodes.contains(c.countryCode))
                  .toList();
              final wantCountries = countries
                  .where((c) => data.wantCodes.contains(c.countryCode))
                  .toList();
              beenCountryPolygons = beenCountries;
              wantCountryPolygons = wantCountries;
              emit(MapState.readCountriesData(
                been: beenCountries,
                want: wantCountries,
              ));
            },
          ),
        );
  }

  List<Country> beenCountryPolygons = [];

  List<Country> wantCountryPolygons = [];

  int get asianCountriesNumber =>
      beenCountryPolygons.where((c) => c.region == 'Asia').length;
  int get allAsianCountriesNumber =>
      countries.where((c) => c.region == 'Asia').length;
  double get asiaPercentage {
    if (allAsianCountriesNumber == 0) return 0;
    return asianCountriesNumber / allAsianCountriesNumber * 100;
  }

  int get europeCountriesNumber =>
      beenCountryPolygons.where((c) => c.region == 'Europe').length;
  int get allEuropeCountriesNumber =>
      countries.where((c) => c.region == 'Europe').length;
  double get europePercentage {
    if (allEuropeCountriesNumber == 0) return 0;
    return europeCountriesNumber / allEuropeCountriesNumber * 100;
  }

  int get northAmericaCountriesNumber =>
      beenCountryPolygons.where((c) => c.region == 'North America').length;
  int get allNorthAmericaCountriesNumber =>
      countries.where((c) => c.region == 'North America').length;
  double get northAmericaPercentage {
    if (allNorthAmericaCountriesNumber == 0) return 0;
    return northAmericaCountriesNumber / allNorthAmericaCountriesNumber * 100;
  }

  int get southAmericaCountriesNumber =>
      beenCountryPolygons.where((c) => c.region == 'South America').length;
  int get allSouthAmericaCountriesNumber =>
      countries.where((c) => c.region == 'South America').length;
  double get southAmericaPercentage {
    if (allSouthAmericaCountriesNumber == 0) return 0;
    return southAmericaCountriesNumber / allSouthAmericaCountriesNumber * 100;
  }

  int get africaCountriesNumber =>
      beenCountryPolygons.where((c) => c.region == 'Africa').length;
  int get allAfricaCountriesNumber =>
      countries.where((c) => c.region == 'Africa').length;
  double get africaPercentage {
    if (allAfricaCountriesNumber == 0) return 0;
    return africaCountriesNumber / allAfricaCountriesNumber * 100;
  }

  int get oceaniaCountriesNumber =>
      beenCountryPolygons.where((c) => c.region == 'Oceania').length;
  int get allOceaniaCountriesNumber =>
      countries.where((c) => c.region == 'Oceania').length;
  double get oceaniaPercentage {
    if (allOceaniaCountriesNumber == 0) return 0;
    return oceaniaCountriesNumber / allOceaniaCountriesNumber * 100;
  }

  void getPointsNumber() {
    final points = countries.map((c) => c.pointsNumber);
    if (points.isNotEmpty) {
      debugPrint(points.reduce((value, element) => value + element).toString());
    }
  }

  Future saveCountriesLocally({
    required List<Country> beenCountries,
    required List<Country> wantCountries,
  }) async {
    await saveCountriesLocallyUsecase
        .call(ManageCountriesLocallyParams(
          beenCodes: beenCountries.map((c) => c.alpha3).toList(),
          wantCodes: wantCountries.map((c) => c.alpha3).toList(),
        ))
        .then(
          (result) => result.fold(
            (failure) => MapState.error(failure.message),
            (data) => emit(MapState.savedCountriesData(
              been: beenCountries,
              want: wantCountries,
            )),
          ),
        );
  }

  void error(String error) => emit(MapState.error(error));
}
