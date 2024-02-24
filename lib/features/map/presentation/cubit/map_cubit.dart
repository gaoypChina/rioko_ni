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
    beenCountryPolygons.add(
        countriesGeoData.firstWhere((country) => country.countryCode == 'POL'));
    wantCountryPolygons.add(
        countriesGeoData.firstWhere((country) => country.countryCode == 'HUN'));
    emit(MapDisplayCountriesData(
        beenCountries: beenCountryPolygons,
        wantCountries: wantCountryPolygons));
  }
}
