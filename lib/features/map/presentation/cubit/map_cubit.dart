import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/core/utils/geolocation_handler.dart';

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

  void load() async {
    _getCurrentPosition();
    await getCountryPolygons().then((_) => getLocalCountryData());
  }

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
    await readCountriesLocallyUsecase.call(NoParams()).then(
          (result) => result.fold(
            (failure) => MapState.error(failure.message),
            (data) {
              countries
                  .where((c) => data.beenCodes.contains(c.alpha3))
                  .forEach((country) => country.status = CountryStatus.been);
              countries
                  .where((c) => data.wantCodes.contains(c.alpha3))
                  .forEach((country) => country.status = CountryStatus.want);
              emit(MapState.readCountriesData(
                been: beenCountries,
                want: wantCountries,
              ));
            },
          ),
        );
  }

  List<Country> get beenCountries =>
      countries.where((c) => c.status == CountryStatus.been).toList();

  List<Country> get wantCountries =>
      countries.where((c) => c.status == CountryStatus.want).toList();

  List<Country> get livedCountries =>
      countries.where((c) => c.status == CountryStatus.lived).toList();

  // Asia

  int get beenAsianCountriesNumber =>
      beenCountries.where((c) => c.region == 'Asia').length;
  double get beenAsiaPercentage {
    if (allAsianCountriesNumber == 0) return 0;
    return beenAsianCountriesNumber / allAsianCountriesNumber * 100;
  }

  int get wantAsianCountriesNumber =>
      wantCountries.where((c) => c.region == 'Asia').length;
  double get wantAsiaPercentage {
    if (allAsianCountriesNumber == 0) return 0;
    return wantAsianCountriesNumber / allAsianCountriesNumber * 100;
  }

  int get allAsianCountriesNumber =>
      countries.where((c) => c.region == 'Asia').length;

  // Europe

  int get beenEuropeCountriesNumber =>
      beenCountries.where((c) => c.region == 'Europe').length;
  double get beenEuropePercentage {
    if (allEuropeCountriesNumber == 0) return 0;
    return beenEuropeCountriesNumber / allEuropeCountriesNumber * 100;
  }

  int get wantEuropeCountriesNumber =>
      beenCountries.where((c) => c.region == 'Europe').length;
  double get wantEuropePercentage {
    if (allEuropeCountriesNumber == 0) return 0;
    return wantEuropeCountriesNumber / allEuropeCountriesNumber * 100;
  }

  int get allEuropeCountriesNumber =>
      countries.where((c) => c.region == 'Europe').length;

  // North America

  int get beenNorthAmericaCountriesNumber =>
      beenCountries.where((c) => c.subregion == 'North America').length;
  double get beenNorthAmericaPercentage {
    if (allNorthAmericaCountriesNumber == 0) return 0;
    return beenNorthAmericaCountriesNumber /
        allNorthAmericaCountriesNumber *
        100;
  }

  int get wantNorthAmericaCountriesNumber =>
      wantCountries.where((c) => c.subregion == 'North America').length;
  double get wantNorthAmericaPercentage {
    if (allNorthAmericaCountriesNumber == 0) return 0;
    return wantNorthAmericaCountriesNumber /
        allNorthAmericaCountriesNumber *
        100;
  }

  int get allNorthAmericaCountriesNumber =>
      countries.where((c) => c.subregion == 'North America').length;

  // South America

  int get beenSouthAmericaCountriesNumber =>
      beenCountries.where((c) => c.subregion == 'South America').length;
  double get beenSouthAmericaPercentage {
    if (allSouthAmericaCountriesNumber == 0) return 0;
    return beenSouthAmericaCountriesNumber /
        allSouthAmericaCountriesNumber *
        100;
  }

  int get wantSouthAmericaCountriesNumber =>
      beenCountries.where((c) => c.subregion == 'South America').length;
  double get wantSouthAmericaPercentage {
    if (allSouthAmericaCountriesNumber == 0) return 0;
    return wantSouthAmericaCountriesNumber /
        allSouthAmericaCountriesNumber *
        100;
  }

  int get allSouthAmericaCountriesNumber =>
      countries.where((c) => c.subregion == 'South America').length;

  // Africa

  int get beenAfricaCountriesNumber =>
      beenCountries.where((c) => c.region == 'Africa').length;
  double get beenAfricaPercentage {
    if (allAfricaCountriesNumber == 0) return 0;
    return beenAfricaCountriesNumber / allAfricaCountriesNumber * 100;
  }

  int get wantAfricaCountriesNumber =>
      wantCountries.where((c) => c.region == 'Africa').length;
  double get wantAfricaPercentage {
    if (allAfricaCountriesNumber == 0) return 0;
    return wantAfricaCountriesNumber / allAfricaCountriesNumber * 100;
  }

  int get allAfricaCountriesNumber =>
      countries.where((c) => c.region == 'Africa').length;

  // Oceania

  int get beenOceaniaCountriesNumber =>
      beenCountries.where((c) => c.region == 'Oceania').length;
  double get beenOceaniaPercentage {
    if (allOceaniaCountriesNumber == 0) return 0;
    return beenOceaniaCountriesNumber / allOceaniaCountriesNumber * 100;
  }

  int get wantOceaniaCountriesNumber =>
      wantCountries.where((c) => c.region == 'Oceania').length;
  double get wantOceaniaPercentage {
    if (allOceaniaCountriesNumber == 0) return 0;
    return wantOceaniaCountriesNumber / allOceaniaCountriesNumber * 100;
  }

  int get allOceaniaCountriesNumber =>
      countries.where((c) => c.region == 'Oceania').length;

  // -----

  void getPointsNumber() {
    final points = countries.map((c) => c.pointsNumber);
    if (points.isNotEmpty) {
      debugPrint(points.reduce((value, element) => value + element).toString());
    }
  }

  Future saveCountriesLocally() async {
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

  void updateCountryStatus({
    required Country country,
    required CountryStatus status,
  }) {
    countries.firstWhere((c) => c.alpha3 == country.alpha3).status = status;
    saveCountriesLocally();
    emit(MapState.updatedCountryStatus(country: country, status: status));
  }

  void _getCurrentPosition() async {
    try {
      final position = await GeoLocationHandler.determinePosition();
      final latLng = LatLng(position.latitude, position.longitude);
      emit(MapState.setCurrentPosition(latLng));
    } on PermissionFailure catch (e) {
      emit(MapState.error(e.message));
    } catch (e) {
      emit(MapState.error('$e'));
    }
  }
}
