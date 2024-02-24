import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  List<CountryPolygons> beenCountryPolygons = [];

  List<CountryPolygons> wantCountryPolygons = [];

  Future<void> getPolandPolygon() async {
    await getCountryPolygonUsecase.call('POL').then(
          (result) => result.fold(
            (failure) {
              debugPrint(failure.fullMessage);
              emit(MapError(failure.message));
            },
            (countryPolygons) {
              debugPrint(countryPolygons.toString());
              beenCountryPolygons.add(countryPolygons);
              emit(MapFetchedCountryPolygons(countryPolygons));
            },
          ),
        );
  }

  Future<void> getHungaryPolygon() async {
    await getCountryPolygonUsecase.call('HUN').then(
          (result) => result.fold(
            (failure) {
              debugPrint(failure.fullMessage);
              emit(MapError(failure.message));
            },
            (countryPolygons) {
              debugPrint(countryPolygons.toString());
              wantCountryPolygons.add(countryPolygons);
              emit(MapFetchedCountryPolygons(countryPolygons));
            },
          ),
        );
  }
}
