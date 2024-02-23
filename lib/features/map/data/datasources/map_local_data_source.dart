import 'package:rioko_ni/features/map/data/models/country_polygons_model.dart';

abstract class MapLocalDataSource {
  Future<CountryPolygonsModel> getCountryPolygons({
    required String countryCode,
  });
}
