import 'package:rioko_ni/features/map/data/models/region_model.dart';

abstract class MapRemoteDataSource {
  Future<List<RegionModel>> getCountryRegions({
    required String countryCode,
  });
}
