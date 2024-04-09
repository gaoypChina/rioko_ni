import 'package:flutter/foundation.dart';
import 'package:geobase/geobase.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;

class GeoUtils {
  // returns the are of polygon in square kilometers
  static double calculatePolygonArea(List<LatLng> polygon) {
    return toolkit.SphericalUtil.computeArea(polygon
            .map((p) => toolkit.LatLng(p.latitude, p.longitude))
            .toList()) /
        1000000;
  }

  /// Simplifies the polygon's points by reducing the number of points based on a reduction percentage.
  ///
  /// This function simplifies the polygon by reducing the number of points while aiming to
  /// retain the overall shape of the polygon. The reduction percentage determines how aggressively
  /// the simplification is applied. The higher the reduction percentage, the more points are
  /// removed, resulting in a more simplified shape.
  ///
  /// Parameters:
  ///   - reductionPercentage: The percentage by which to reduce the number of points in the polygon.
  ///     Must be an integer value between 5 and 75, inclusive. A higher percentage leads to more
  ///     aggressive simplification.
  ///
  /// Returns:
  ///   A simplified version of the original polygon's points with a reduced number of points.
  ///
  /// Throws:
  ///   - AssertionError: If the `reductionPercentage` is not within the valid range of 5 to 75.
  ///
  /// Note:
  ///   - If the `reductionPercentage` exceeds 50, the function applies a secondary reduction to
  ///     further simplify the polygon.
  ///   - The algorithm skips points based on the calculated skip value, which is determined by the
  ///     reduction percentage.
  static List<LatLng> simplify(
    List<LatLng> points, {
    required int reductionPercentage,
  }) {
    assert(reductionPercentage >= 5 && reductionPercentage <= 90,
        'Reduction percentage must be between 5 and 75.');

    int secondReduction = 0;
    if (reductionPercentage > 50) {
      // Apply secondary reduction if reduction percentage exceeds 50
      secondReduction = (reductionPercentage - 50) * 2;
      reductionPercentage = 50;
    }
    // Calculate skip value based on reduction percentage
    int skipValue = 100 ~/ reductionPercentage;

    List<LatLng> basePoints = [...points];
    List<LatLng> resultPoints = [];

    int i = 0;
    do {
      List<LatLng> points = [];
      for (int i = 0; i < basePoints.length; i++) {
        // Skip points based on skip value. Skips neither first nor last point.
        if (i != 0 && i != basePoints.length - 1 && i % skipValue == 0) {
          continue;
        }
        points.add(basePoints[i]);
      }

      // Apply secondary reduction if necessary
      if (secondReduction != 0) {
        skipValue = 100 ~/ secondReduction;
        basePoints = [...points];
      }

      // Copy result
      resultPoints = points;

      i++;
    } while (secondReduction != 0 && i < 2);

    return resultPoints;
  }

  static List<List<List<double>>> extractPolygonsFromFeatureCollection(
    FeatureCollection featureCollection,
  ) {
    List<List<LatLng>> result = [];

    // Iterate through each GeoJSON feature in the collection
    for (Feature feature in featureCollection.features) {
      List<Polygon> polygons = [];

      // Extract polygons from the feature's geometry
      if (feature.geometry is Polygon) {
        polygons.add(feature.geometry as Polygon);
      }
      if (feature.geometry is MultiPolygon) {
        var multiPolygon = feature.geometry as MultiPolygon;

        polygons = [...multiPolygon.polygons];
      }

      // Process each polygon
      for (Polygon polygon in polygons) {
        List<LatLng> points = [];

        // Skip polygons without exterior positions
        if (polygon.exterior == null) continue;

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

        final area = GeoUtils.calculatePolygonArea(points);

        // Skip polygons that area is smaller that threshold
        if (result.isNotEmpty && area < 500) {
          continue;
        }

        // Apply simplification if the number of points exceeds the points number threshold
        if (points.length > 100) {
          points = simplify(points, reductionPercentage: 75);
        }

        result = [
          ...result,
          points,
        ];
      }
    }
    return result
        .map((p) => p.map((p2) => [p2.latitude, p2.longitude]).toList())
        .toList();
  }
}
