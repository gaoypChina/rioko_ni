import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/core/utils/exception_handler.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/datasources/map_remote_data_source.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';
import 'package:rioko_ni/features/map/domain/entities/region.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';

class MapRepositoryImpl with ExceptionHandler implements MapRepository {
  final MapLocalDataSource localDataSource;
  final MapRemoteDataSource remoteDataSource;

  const MapRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Country>>> getCountryPolygons() async {
    return await execute(() async {
      final result = await localDataSource.getCountries();
      return result.map((country) => country.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<Region>>> getCountryRegions(
      String countryCode) async {
    return await execute(() async {
      final result =
          await remoteDataSource.getCountryRegions(countryCode: countryCode);
      return result.map((country) => country.toEntity()).toList();
    });
  }
}
