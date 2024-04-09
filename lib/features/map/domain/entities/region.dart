import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:rioko_ni/features/map/data/models/region_model.dart';

part 'region.freezed.dart';

@unfreezed
class Region with _$Region {
  const Region._();
  factory Region({
    /// GeoJson data
    required List<List<LatLng>> polygons,
    required String code,
    required String name,
    required String type,
    required String countryCode,
    required String engType,
  }) = _Region;

  RegionModel toModel() => RegionModel(
        code: code,
        polygons: polygons
            .map((p) => p.map((p2) => [p2.latitude, p2.longitude]).toList())
            .toList(),
        name: name,
        type: type,
        countryCode: countryCode,
        engType: engType,
      );
}
