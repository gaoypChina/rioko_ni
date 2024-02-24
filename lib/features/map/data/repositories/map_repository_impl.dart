import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/core/utils/exception_handler.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/datasources/map_remote_data_source.dart';
import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';

class MapRepositoryImpl with ExceptionHandler implements MapRepository {
  final MapRemoteDataSource remoteDataSource;
  final MapLocalDataSource localDataSource;

  const MapRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, CountryPolygons>> getCountryPolygons({
    required String countryCode,
  }) async {
    return await execute(() async {
      final result =
          await localDataSource.getCountryPolygons(countryCode: countryCode);
      return result.toEntity();
    });
  }
}
