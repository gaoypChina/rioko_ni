import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';

class GetCountryPolygons extends UseCase<List<CountryPolygons>, NoParams> {
  final MapRepository repository;

  GetCountryPolygons(this.repository);

  /// [ISO 3166-1 alpha-3] countryCode as params
  @override
  Future<Either<Failure, List<CountryPolygons>>> call(NoParams params) async {
    return await repository.getCountryPolygons();
  }
}
