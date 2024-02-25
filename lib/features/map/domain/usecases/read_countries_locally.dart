import 'package:dartz/dartz.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';
import 'package:rioko_ni/features/map/domain/usecases/save_countries_locally.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

class ReadCountriesLocally
    extends UseCase<ManageCountriesLocallyParams, Countries> {
  final MapRepository repository;

  ReadCountriesLocally(this.repository);

  @override
  Future<Either<Failure, ManageCountriesLocallyParams>> call(
      Countries params) async {
    return await repository.readCountriesLocally(params: params);
  }
}
