import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rioko_ni/core/domain/usecase.dart';
import 'package:rioko_ni/core/errors/failure.dart';
import 'package:rioko_ni/features/map/domain/repositories/map_repository.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

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
  final Countries? type;

  const ManageCountriesLocallyParams.read({
    required this.beenCodes,
    required this.wantCodes,
  }) : type = null;

  const ManageCountriesLocallyParams.save({
    required this.beenCodes,
    required this.wantCodes,
    required Countries this.type,
  });

  @override
  List<Object> get props => [beenCodes, wantCodes];
}
