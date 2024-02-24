import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rioko_ni/core/domain/usecase.dart';

import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';
import 'package:rioko_ni/features/map/domain/usecases/get_country_polygons.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final GetCountryPolygons getCountryPolygonUsecase;
  MapCubit({
    required this.getCountryPolygonUsecase,
  }) : super(MapInitial());

  String get urlTemplate =>
      "https://api.mapbox.com/styles/v1/mister-lucifer/cls7n0t4g00zh01qsdc652wos/tiles/256/{z}/{x}/{y}{r}?access_token={accessToken}";

  List<CountryPolygons> countriesGeoData = [];

  Future getCountryPolygons() async {
    await getCountryPolygonUsecase.call(NoParams()).then(
          (result) => result.fold(
            (failure) => emit(MapError(failure.message)),
            (countryPolygons) {
              countriesGeoData = countryPolygons;
              emit(MapFetchedCountryPolygons(countryPolygons));
            },
          ),
        );
  }

  List<CountryPolygons> beenCountryPolygons = [];

  List<CountryPolygons> wantCountryPolygons = [];

  void displayPolygons() {
    beenCountryPolygons.addAll(
      countriesGeoData.getRange(0, countriesGeoData.length ~/ 2),
    );
    wantCountryPolygons.addAll(
      countriesGeoData.getRange(
          countriesGeoData.length ~/ 2, countriesGeoData.length),
    );
    emit(MapDisplayCountriesData(
        beenCountries: beenCountryPolygons,
        wantCountries: wantCountryPolygons));
  }

  void getPointsNumber() {
    final points = countriesGeoData.map((c) => c.pointsNumber);
    if (points.isNotEmpty) {
      debugPrint(points.reduce((value, element) => value + element).toString());
    }
  }
}
