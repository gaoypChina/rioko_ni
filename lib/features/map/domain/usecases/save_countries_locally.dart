import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';

class SaveCountriesLocally extends UseCase<void, ManageCountriesLocallyParams> {
  final MapRepository repository;

  SaveCountriesLocally(this.repository);

  @override
  Future<Either<Failure, void>> call(
      ManageCountriesLocallyParams params) async {
    return await repository.saveCountriesLocally(params: params);
  }
}

class ManageCountriesLocallyParams extends Equatable {
  final List<String> beenCodes;
  final List<String> wantCodes;

  const ManageCountriesLocallyParams({
    required this.beenCodes,
    required this.wantCodes,
  });
  @override
  List<Object> get props => [beenCodes, wantCodes];
}
