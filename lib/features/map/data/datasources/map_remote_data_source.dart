import 'package:rioko_ni/features/map/data/models/region_model.dart';

abstract class MapRemoteDataSource {
  Future<RegionModel> getCountries({
    required String countryCode,
  });
}
