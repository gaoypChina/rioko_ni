import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rioko_ni/core/extensions/polygon2.dart';
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
    required String region,
    required String subregion,

    /// English name
    required String name,
  }) = _CountryPolygons;

  CountryPolygonsModel toModel() => CountryPolygonsModel(
        countryCode: countryCode,
        featureCollection: featureCollection,
        region: region,
        subregion: subregion,
        name: name,
      );

  /// Generates Flutter Map polygons from GeoJSON features.
  ///
  /// This method generates Flutter Map polygons from GeoJSON features
  /// representing the country's borders. It allows customization of
  /// polygon appearance such as border color, width, and simplification
  /// percentage.
  ///
  /// Parameters:
  ///   - borderColor: The color of the polygon border.
  ///   - borderWidth: The width of the polygon border.
  ///   - reductionPercentage: The percentage by which to reduce the number of points
  ///     in each polygon. Default is 75.
  ///   - pointsNumberReductionThreshold: The threshold number of points in a polygon
  ///     above which simplification is applied. Default is 1000.
  ///
  /// Returns:
  ///   A list of Flutter Map polygons representing the country's borders.
  ///
  List<fm.Polygon> polygons({
    Color? borderColor,
    double? borderWidth,
    int reductionPercentage = 75,
    int pointsNumberReductionThreshold = 1000,
  }) {
    List<fm.Polygon> result = [];

    borderColor ??= Colors.red;
    borderWidth ??= 2.0;

    // Iterate through each GeoJSON feature in the collection
    for (Feature feature in featureCollection.features) {
      List<Polygon> polygons = [];

      // Extract polygons from the feature's geometry
      if (feature.geometry is Polygon) {
        polygons.add(feature.geometry as Polygon);
      }
      if (feature.geometry is MultiPolygon) {
        var multiPolygon = feature.geometry as MultiPolygon;

        // For MultiPolygon, sort Polygons from highest number of points to lowest.
        polygons = [
          ...multiPolygon.polygons.toList()
            ..sort((a, b) {
              final bPositionsLength = b.exterior!.positions.length;
              final aPositionsLength = a.exterior!.positions.length;
              return bPositionsLength.compareTo(aPositionsLength);
            })
        ];
      }

      // Process each polygon
      for (Polygon polygon in polygons) {
        List<LatLng> points = [];

        // Skip polygons without exterior positions
        if (polygon.exterior == null) continue;

        // Calculate the threshold for the number of polygons
        int polygonsNumberThreshold = polygons.length ~/ 3;
        if (polygonsNumberThreshold > 10) {
          polygonsNumberThreshold = 10;
        }
        if (polygonsNumberThreshold < 1) {
          polygonsNumberThreshold = 1;
        }

        // Check if the polygons number threshold is reached
        if (result.length >= polygonsNumberThreshold) {
          return result;
        }

        // Convert GeoJSON positions to LatLng points
        polygon.exterior?.positions.forEach((position) {
          double latitude = position.y;
          double longitude = position.x;

          // Ensure longitude is within the valid range of flutter_map coordination system
          if (longitude <= -180 || longitude >= 180) {
            longitude = longitude.clamp(-179.999999, 179.999999);
          }

          points.add(LatLng(latitude, longitude));
        });

        // Skip invalid polygons
        if (points.isEmpty ||
            points.length < 2 ||
            points.first != points.last) {
          continue;
        }

        fm.Polygon fmPolygon = fm.Polygon(
          points: points,
          borderColor: borderColor,
          borderStrokeWidth: borderWidth,
          isFilled: true,
          color: borderColor.withOpacity(0.3),
        );

        // Apply simplification if the number of points exceeds the points number threshold
        if (fmPolygon.points.length > pointsNumberReductionThreshold) {
          fmPolygon = Polygon2(fmPolygon)
              .simplify(reductionPercentage: reductionPercentage);
        }

        result = [
          ...result,
          fmPolygon,
        ];
      }
    }
    return result;
  }

  /// Calculates the total number of points in all polygons.
  int get pointsNumber {
    final points = polygons().map((p) => p.points.length).toList();

    if (points.isNotEmpty) {
      return points.reduce((value, element) => value + element);
    }

    return -1;
  }
}
