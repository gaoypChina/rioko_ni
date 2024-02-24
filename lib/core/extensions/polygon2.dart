import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

extension Polygon2 on Polygon {
  /// Simplifies the polygon by reducing the number of points based on a reduction percentage.
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
  ///   A simplified version of the original polygon with a reduced number of points.
  ///
  /// Throws:
  ///   - AssertionError: If the `reductionPercentage` is not within the valid range of 5 to 75.
  ///
  /// Note:
  ///   - If the `reductionPercentage` exceeds 50, the function applies a secondary reduction to
  ///     further simplify the polygon.
  ///   - The algorithm skips points based on the calculated skip value, which is determined by the
  ///     reduction percentage.
  Polygon simplify({
    required int reductionPercentage,
  }) {
    assert(reductionPercentage >= 5 && reductionPercentage <= 75,
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

    return Polygon(
      points: resultPoints,
      holePointsList: holePointsList,
      color: color,
      borderColor: borderColor,
      borderStrokeWidth: borderStrokeWidth,
      isDotted: isDotted,
      isFilled: isFilled,
      disableHolesBorder: disableHolesBorder,
      label: label,
      strokeCap: strokeCap,
      strokeJoin: strokeJoin,
      labelPlacement: labelPlacement,
      rotateLabel: rotateLabel,
      labelStyle: labelStyle,
    );
  }
}
