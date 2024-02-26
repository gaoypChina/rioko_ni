import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';

class ReadCountriesLocally
    extends UseCase<ManageCountriesLocallyParams, NoParams> {
  final MapRepository repository;

  ReadCountriesLocally(this.repository);

  @override
  Future<Either<Failure, ManageCountriesLocallyParams>> call(
      NoParams params) async {
    return await repository.readCountriesLocally();
  }
}
