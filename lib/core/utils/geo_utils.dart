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
}
