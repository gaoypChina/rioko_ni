import 'package:rioko_ni/core/data/gadm_client.dart';
import 'package:rioko_ni/features/map/data/datasources/map_remote_data_source.dart';

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final GADMClient client;

  const MapRemoteDataSourceImpl({required this.client});
}
