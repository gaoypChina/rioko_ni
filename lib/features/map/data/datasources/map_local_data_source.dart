import 'package:rioko_ni/features/map/data/models/country_model.dart';

abstract class MapLocalDataSource {
  Future<List<CountryModel>> getCountries();
}
