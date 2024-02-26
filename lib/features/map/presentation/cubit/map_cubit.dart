import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rioko_ni/core/domain/usecase.dart';

import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';
import 'package:rioko_ni/features/map/domain/usecases/get_country_polygons.dart';
import 'package:rioko_ni/features/map/domain/usecases/read_countries_locally.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';

part 'map_state.dart';

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

  Future getLocalCountryData() async {
    await readCountriesLocallyUsecase.call(NoParams()).then(
          (result) => result.fold(
            (failure) => MapError(failure.message),
            (data) {
              final countries = countriesGeoData
                  .where((c) => data.beenCodes.contains(c.countryCode))
                  .toList();
              beenCountryPolygons = countries;
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
}
