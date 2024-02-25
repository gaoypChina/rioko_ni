import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

abstract class MapRepository {
  Future<Either<Failure, List<CountryPolygons>>> getCountryPolygons();
  Future<Either<Failure, void>> saveCountriesLocally({
    required ManageCountriesLocallyParams params,
  });
  Future<Either<Failure, ManageCountriesLocallyParams>> readCountriesLocally({
    required Countries params,
  });
}
