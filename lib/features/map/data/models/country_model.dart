import 'package:country_code/country_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geobase/geobase.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';

part 'country_model.freezed.dart';

@freezed
class CountryModel with _$CountryModel {
  const CountryModel._();
  factory CountryModel({
    required FeatureCollection featureCollection,
    required String countryCode,
    required Region region,
  }) = _CountryPolygonsModel;

  Country toEntity() => Country(
        countryCode: CountryCode.parse(countryCode),
        featureCollection: featureCollection,
        region: region,
      );
}
