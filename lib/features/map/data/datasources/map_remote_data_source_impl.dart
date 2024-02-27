import 'package:geobase/geobase.dart';
import 'package:rioko_ni/core/data/gadm_client.dart';
import 'package:rioko_ni/core/errors/exception.dart';
import 'package:rioko_ni/features/map/data/datasources/map_remote_data_source.dart';
import 'package:rioko_ni/features/map/data/models/country_model.dart';

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final GADMClient client;

  const MapRemoteDataSourceImpl({required this.client});

  @override
  Future<CountryModel> getCountries({
    required String countryCode,
  }) async {
    try {
      final httpResponse =
          await client.getCountryPolygon(countryCode: countryCode);
      if (httpResponse.response.statusCode != 200) {
        throw ServerException(httpResponse.response.toString(),
            stack: StackTrace.current);
      }
      final featureCollection = FeatureCollection.fromData(httpResponse.data);
      return CountryModel(
        countryCode: countryCode,
        featureCollection: featureCollection,
        region: '',
        subregion: '',
        name: '',
      );
    } on ServerException {
      rethrow;
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }
}
