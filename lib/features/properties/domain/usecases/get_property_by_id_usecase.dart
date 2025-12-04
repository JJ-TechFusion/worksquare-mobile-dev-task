import 'package:dartz/dartz.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';
import 'package:dreamdwell/features/properties/domain/repositories/property_repository.dart';

class GetPropertyByIdUsecase {
  final PropertyRepository repository;

  GetPropertyByIdUsecase(this.repository);

  Future<Either<String, PropertyEntity>> call(int propertyId) async {
    return await repository.getPropertyById(propertyId);
  }
}
