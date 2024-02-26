part of 'map_cubit.dart';

@freezed
class MapState with _$MapState {
  const factory MapState.initial() = _Initial;

  const factory MapState.fetchedCountryPolygons(
      List<CountryPolygons> polygons) = _FetchedCountryPolygons;

  const factory MapState.readCountriesData({
    required List<CountryPolygons> been,
    required List<CountryPolygons> want,
  }) = _ReadCountriesData;

  const factory MapState.savedCountriesData({
    required List<CountryPolygons> been,
    required List<CountryPolygons> want,
  }) = _SavedCountriesData;

  const factory MapState.error(String message) = _Error;
}
