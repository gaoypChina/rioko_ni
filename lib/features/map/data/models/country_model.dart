import 'package:country_code/country_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';

part 'country_model.freezed.dart';

@freezed
class CountryModel with _$CountryModel {
  const CountryModel._();
  factory CountryModel({
    required List<List<List<double>>> polygons,
    required String countryCode,
    required Region region,
  }) = _CountryPolygonsModel;

  Country toEntity() {
    final poly = polygons
        .map((p) => p.map((p2) => LatLng(p2.first, p2.last)).toList())
        .toList();
    return Country(
      countryCode: CountryCode.parse(countryCode),
      polygons: poly,
      region: region,
    );
  }
}
