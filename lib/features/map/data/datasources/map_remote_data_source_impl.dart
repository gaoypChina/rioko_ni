import 'package:geobase/geobase.dart';
import 'package:rioko_ni/core/data/gadm_client.dart';
import 'package:rioko_ni/core/errors/exception.dart';
import 'package:rioko_ni/core/utils/geo_utils.dart';
import 'package:rioko_ni/features/map/data/datasources/map_remote_data_source.dart';
import 'package:rioko_ni/features/map/data/models/region_model.dart';

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final GADMClient client;

  const MapRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RegionModel>> getCountryRegions({
    required String countryCode,
  }) async {
    try {
      final httpResponse =
          await client.getCountryRegions(countryCode: countryCode);
      if (httpResponse.response.statusCode != 200) {
        throw ServerException(httpResponse.response.toString(),
            stack: StackTrace.current);
      }

      final featureCollection = FeatureCollection.fromData(httpResponse.data);

      return featureCollection.features.map((feature) {
        final name = feature.properties["NAME_1"];
        final type = feature.properties["TYPE_1"];
        final engType = feature.properties["ENGTYPE_1"];
        final code = feature.properties["CC_1"];

        final List<List<List<double>>> polygons =
            GeoUtils.extractPolygonsFromFeatureCollection(featureCollection);

        return RegionModel(
          countryCode: countryCode,
          code: code,
          name: name,
          type: type,
          engType: engType,
          polygons: polygons,
        );
      }).toList();
    } on ServerException {
      rethrow;
    } catch (e, stack) {
      throw RequestException(e.toString(), stack: stack);
    }
  }
}
