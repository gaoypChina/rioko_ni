import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';

abstract class MapRepository {
  Future<Either<Failure, List<Country>>> getCountryPolygons();
}
