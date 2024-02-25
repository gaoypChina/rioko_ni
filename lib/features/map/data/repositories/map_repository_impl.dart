import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/core/utils/exception_handler.dart';
import 'package:rioko_ni/features/map/data/datasources/map_local_data_source.dart';
import 'package:rioko_ni/features/map/data/datasources/map_remote_data_source.dart';
import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

class MapRepositoryImpl with ExceptionHandler implements MapRepository {
  final MapRemoteDataSource remoteDataSource;
  final MapLocalDataSource localDataSource;

  const MapRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<CountryPolygons>>> getCountryPolygons() async {
    return await execute(() async {
      final result = await localDataSource.getCountryPolygons();
      return result.map((country) => country.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, void>> saveCountriesLocally({
    required ManageCountriesLocallyParams params,
  }) async {
    return await execute(() async {
      await localDataSource.saveCountriesLocally(params: params);
    });
  }

  @override
  Future<Either<Failure, ManageCountriesLocallyParams>> readCountriesLocally({
    required Countries params,
  }) async {
    return await execute(() async {
      final data = await localDataSource.readCountriesLocally(params: params);
      return data;
    });
  }
}
