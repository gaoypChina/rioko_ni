import 'package:rioko_ni/features/map/data/models/country_model.dart';

abstract class MapRemoteDataSource {
  Future<CountryModel> getCountries({
    required String countryCode,
  });
}
