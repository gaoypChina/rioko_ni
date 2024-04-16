part of 'map_cubit.dart';

@freezed
class MapState with _$MapState {
  const factory MapState.initial() = _Initial;

  const factory MapState.loading() = _Loading;

  const factory MapState.gotDir(String dir) = _GotDir;

  const factory MapState.fetchedCountryPolygons(List<Country> polygons) =
      _FetchedCountryPolygons;

  const factory MapState.readCountriesData({
    required List<Country> been,
    required List<Country> want,
    required List<Country> lived,
  }) = _ReadCountriesData;

  const factory MapState.savedCountriesData({
    required List<Country> been,
    required List<Country> want,
    required List<Country> lived,
  }) = _SavedCountriesData;

  const factory MapState.updatedCountryStatus({
    required Country country,
    required CountryStatus status,
  }) = _UpdatedCountryStatus;

  const factory MapState.setCurrentPosition(LatLng position) =
      _SetCurrentPosition;

  const factory MapState.fetchedRegions(List<Region> regions) = _FetchedRegions;

  const factory MapState.error(String message) = _Error;
}
