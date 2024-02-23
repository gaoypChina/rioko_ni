import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/entities/country_polygons.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';

class GetCountryPolygons extends UseCase<CountryPolygons, String> {
  final MapRepository repository;

  GetCountryPolygons(this.repository);

  @override
  Future<Either<Failure, CountryPolygons>> call(String countryCode) async {
    return await repository.getCountryPolygons(countryCode: countryCode);
  }
}
