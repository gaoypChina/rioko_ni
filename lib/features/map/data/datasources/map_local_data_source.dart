import 'package:rioko_ni/features/map/data/models/country_model.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';

abstract class MapLocalDataSource {
  Future<List<CountryModel>> getCountries();
  Future<void> saveCountriesLocally({
    required ManageCountriesLocallyParams params,
  });

  Future<ManageCountriesLocallyParams> readCountriesLocally();
}
