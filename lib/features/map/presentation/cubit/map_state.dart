part of 'map_cubit.dart';

@freezed
class MapState with _$MapState {
  const factory MapState.initial() = _Initial;

  const factory MapState.fetchedCountryPolygons(List<Country> polygons) =
      _FetchedCountryPolygons;

  const factory MapState.readCountriesData({
    required List<Country> been,
    required List<Country> want,
  }) = _ReadCountriesData;

  const factory MapState.savedCountriesData({
    required List<Country> been,
    required List<Country> want,
  }) = _SavedCountriesData;

  const factory MapState.updatedCountryStatus({
    required Country country,
    required CountryStatus status,
  }) = _UpdatedCountryStatus;

  const factory MapState.setCurrentPosition(LatLng position) =
      _SetCurrentPosition;

  const factory MapState.error(String message) = _Error;
}
