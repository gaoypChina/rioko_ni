import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rioko_ni/core/domain/usecase.dart';

import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';
import 'package:rioko_ni/features/map/domain/usecases/get_country_polygons.dart';
import 'package:rioko_ni/features/map/domain/usecases/read_countries_locally.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';

part 'map_state.dart';
part 'map_cubit.freezed.dart';

enum Countries {
  been,
  want,
}

class MapCubit extends Cubit<MapState> {
  final GetCountryPolygons getCountryPolygonUsecase;
  final ReadCountriesLocally readCountriesLocallyUsecase;
  final SaveCountriesLocally saveCountriesLocallyUsecase;
  MapCubit({
    required this.getCountryPolygonUsecase,
    required this.readCountriesLocallyUsecase,
    required this.saveCountriesLocallyUsecase,
  }) : super(const MapState.initial());

  String get urlTemplate =>
      "https://api.mapbox.com/styles/v1/mister-lucifer/cls7n0t4g00zh01qsdc652wos/tiles/256/{z}/{x}/{y}{r}?access_token={accessToken}";

  List<CountryPolygons> countriesGeoData = [];

  Future getCountryPolygons() async {
    await getCountryPolygonUsecase.call(NoParams()).then(
          (result) => result.fold(
            (failure) => emit(MapState.error(failure.message)),
            (countryPolygons) {
              countriesGeoData = countryPolygons;
              emit(MapState.fetchedCountryPolygons(countryPolygons));
            },
          ),
        );
  }

  Future getLocalCountryData() async {
    debugPrint('start');
    await readCountriesLocallyUsecase.call(NoParams()).then(
          (result) => result.fold(
            (failure) => MapState.error(failure.message),
            (data) {
              final beenCountries = countriesGeoData
                  .where((c) => data.beenCodes.contains(c.countryCode))
                  .toList();
              final wantCountries = countriesGeoData
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

  List<CountryPolygons> beenCountryPolygons = [];

  List<CountryPolygons> wantCountryPolygons = [];

  void getPointsNumber() {
    final points = countriesGeoData.map((c) => c.pointsNumber);
    if (points.isNotEmpty) {
      debugPrint(points.reduce((value, element) => value + element).toString());
    }
  }

  Future saveCountriesLocally({
    required List<CountryPolygons> beenCountries,
    required List<CountryPolygons> wantCountries,
  }) async {
    await saveCountriesLocallyUsecase
        .call(ManageCountriesLocallyParams(
          beenCodes: beenCountries.map((c) => c.countryCode).toList(),
          wantCodes: wantCountries.map((c) => c.countryCode).toList(),
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
