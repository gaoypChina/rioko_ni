import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';

class GetCountries extends UseCase<List<Country>, NoParams> {
  final MapRepository repository;

  GetCountries(this.repository);

  /// [ISO 3166-1 alpha-3] countryCode as params
  @override
  Future<Either<Failure, List<Country>>> call(NoParams params) async {
    return await repository.getCountryPolygons();
  }
}
