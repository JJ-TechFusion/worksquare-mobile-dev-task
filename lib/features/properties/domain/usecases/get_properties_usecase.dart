import 'package:dartz/dartz.dart';
import 'package:dreamdwell/core/utils/no_params.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';
import 'package:dreamdwell/features/properties/domain/repositories/property_repository.dart';

class GetPropertiesUsecase {
  final PropertyRepository repository;

  GetPropertiesUsecase(this.repository);

  Future<Either<String, List<PropertyEntity>>> call(NoParams params) async {
    return await repository.getProperties();
  }
}
