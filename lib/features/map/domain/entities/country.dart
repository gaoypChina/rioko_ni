import 'package:country_code/country_code.dart';
import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rioko_ni/features/map/data/models/country_model.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:rioko_ni/main.dart';
import 'package:point_in_polygon/point_in_polygon.dart' as pip;

part 'country.freezed.dart';

enum CountryStatus {
  none,
  been,
  want,
  lived,
}

enum Region {
  northAmerica,
  southAmerica,
  europe,
  africa,
  asia,
  oceania,
  antarctic,
}

extension RegionExtension on Region {
  static Region fromString(String name) {
    switch (name) {
      case 'Asia':
        return Region.asia;
      case 'Africa':
        return Region.africa;
      case 'North America':
        return Region.northAmerica;
      case 'South America':
        return Region.southAmerica;
      case 'Oceania':
        return Region.oceania;
      case 'Antarctic':
        return Region.antarctic;
      case 'Europe':
        return Region.europe;
      default:
        return Region.asia;
    }
  }

  String get name {
    switch (this) {
      case Region.africa:
        return tr('regions.africa');
      case Region.antarctic:
        return tr('regions.antarctic');
      case Region.asia:
        return tr('regions.asia');
      case Region.europe:
        return tr('regions.europe');
      case Region.northAmerica:
        return tr('regions.northAmerica');
      case Region.southAmerica:
        return tr('regions.southAmerica');
      case Region.oceania:
        return tr('regions.oceania');
    }
  }
}

extension CountryStatusExtension on CountryStatus {
  Color get color {
    final context = RiokoNi.navigatorKey.currentContext;
    if (context == null) return Colors.transparent;
    final scheme = Theme.of(context).colorScheme;
    switch (this) {
      case CountryStatus.been:
        return scheme.onPrimary;
      case CountryStatus.want:
        return scheme.onSecondary;
      case CountryStatus.lived:
        return scheme.onTertiary;
      default:
        return Colors.transparent;
    }
  }
}

@unfreezed
class Country with _$Country {
  const Country._();
  factory Country({
    /// GeoJson data
    required List<List<LatLng>> polygons,
    required CountryCode countryCode,
    required Region region,
    @Default(CountryStatus.none) CountryStatus status,
  }) = _Country;

  CountryModel toModel() => CountryModel(
        countryCode: countryCode.alpha3,
        polygons: polygons
            .map((p) => p.map((p2) => [p2.latitude, p2.longitude]).toList())
            .toList(),
        region: region,
      );

  String get alpha2 => countryCode.alpha2;
  String get alpha3 => countryCode.alpha3;

  String get name => tr('countries.$alpha3');

  bool contains(LatLng position) {
    final bounds = polygons.map((p) => fm.LatLngBounds.fromPoints(p)).toList();
    // First check if the position is in the bounding box
    final result = bounds.where((b) => b.contains(position));
    if (result.isEmpty) return false;
    // And then execute more complex method to check if position is inside the geometry
    return bounds.any(
      (b) {
        final i = bounds.indexOf(b);
        return pip.Poly.isPointInPolygon(
          pip.Point(x: position.longitude, y: position.latitude),
          polygons[i]
              .map((latLng) =>
                  pip.Point(x: latLng.longitude, y: latLng.latitude))
              .toList(),
        );
      },
    );
  }

  Widget flag({
    double scale = 1,
    double borderRadius = 0,
  }) {
    const double height = 48;
    const double width = 62;
    return CountryFlag.fromCountryCode(
      alpha2,
      height: height * scale,
      width: width * scale,
      borderRadius: borderRadius,
    );
  }
}
