import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geobase/geobase.dart';
import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';

part 'country_polygons_model.freezed.dart';

@freezed
class CountryPolygonsModel with _$CountryPolygonsModel {
  const CountryPolygonsModel._();
  factory CountryPolygonsModel({
    required FeatureCollection featureCollection,
    required String countryCode,
    required String region,
    required String subregion,
    required String name,
  }) = _CountryPolygonsModel;

  CountryPolygons toEntity() => CountryPolygons(
        countryCode: countryCode,
        featureCollection: featureCollection,
        region: region,
        subregion: subregion,
        name: name,
      );
}
