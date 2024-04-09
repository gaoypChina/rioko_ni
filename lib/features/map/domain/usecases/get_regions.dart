import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/entities/region.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';

class GetCountryRegions extends UseCase<List<Region>, String> {
  final MapRepository repository;

  GetCountryRegions(this.repository);

  /// [ISO 3166-1 alpha-3] countryCode as params
  @override
  Future<Either<Failure, List<Region>>> call(String countryCode) async {
    assert(countryCode.length == 3,
        'Country code has to be in [ISO 3166-1 alpha-3] format');
    return await repository.getCountryRegions(countryCode);
  }
}
