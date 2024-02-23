import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rioko_ni/features/map/data/models/country_polygons_model.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:geobase/geobase.dart';
import 'package:latlong2/latlong.dart';

part 'country_polygons.freezed.dart';

@freezed
class CountryPolygons with _$CountryPolygons {
  const CountryPolygons._();
  factory CountryPolygons({
    required FeatureCollection featureCollection,
    required String countryCode,
  }) = _CountryPolygons;

  CountryPolygonsModel toModel() => CountryPolygonsModel(
        countryCode: countryCode,
        featureCollection: featureCollection,
      );

  List<fm.Polygon> get polygons {
    List<fm.Polygon> result = [];
    for (Feature feature in featureCollection.features) {
      if (feature.geometry is Polygon) {
        List<LatLng> points = [];
        (feature.geometry as Polygon).exterior?.positions.forEach((position) {
          points.add(LatLng(position.y, position.x));
        });
        return [
          fm.Polygon(
              points: points, borderColor: Colors.red, borderStrokeWidth: 2.0)
        ];
      }
      if (feature.geometry is MultiPolygon) {
        var multiPolygon = feature.geometry as MultiPolygon;
        for (Polygon polygon in multiPolygon.polygons) {
          List<LatLng> points = [];
          polygon.exterior?.positions.forEach((position) {
            points.add(LatLng(position.y, position.x));
          });
          if (points.isNotEmpty &&
              points.length > 2 &&
              points.first == points.last) {
            result = [
              ...result,
              fm.Polygon(
                  points: points,
                  borderColor: Colors.red,
                  borderStrokeWidth: 2.0)
            ];
          }
        }
      }
    }
    return result;
  }

  fm.Polygon get polygon {
    List<LatLng> points = [];
    for (Feature feature in featureCollection.features) {
      if (feature.geometry is MultiPolygon) {
        var multiPolygon = feature.geometry as MultiPolygon;
        for (Polygon polygon in multiPolygon.polygons) {
          polygon.exterior?.positions.forEach((position) {
            points.add(LatLng(position.y, position.x));
          });
        }
      }
    }
    return fm.Polygon(
        points: points,
        color: Colors.red,
        borderColor: Colors.red,
        borderStrokeWidth: 5.0);
  }
}
