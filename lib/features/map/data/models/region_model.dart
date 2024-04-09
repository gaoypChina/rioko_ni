import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko_ni/features/map/domain/entities/region.dart';

part 'region_model.freezed.dart';

@freezed
class RegionModel with _$RegionModel {
  const RegionModel._();
  factory RegionModel({
    required List<List<List<double>>> polygons,
    // ISO 3166-2 region code
    required String code,
    required String name,
    required String type,
    required String countryCode,
    required String engType,
  }) = _RegionModel;

  Region toEntity() {
    final poly = polygons
        .map((p) => p.map((p2) => LatLng(p2.first, p2.last)).toList())
        .toList();
    return Region(
      code: code,
      polygons: poly,
      name: name,
      type: type,
      countryCode: countryCode,
      engType: engType,
    );
  }
}
