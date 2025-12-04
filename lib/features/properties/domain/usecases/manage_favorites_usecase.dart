import 'package:dartz/dartz.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';
import 'package:dreamdwell/features/properties/domain/repositories/property_repository.dart';

class GetFavoritePropertiesUsecase {
  final PropertyRepository repository;

  GetFavoritePropertiesUsecase(this.repository);

  Future<Either<String, List<PropertyEntity>>> call() async {
    return await repository.getFavoriteProperties();
  }
}

class AddToFavoritesUsecase {
  final PropertyRepository repository;

  AddToFavoritesUsecase(this.repository);

  Future<Either<String, void>> call(int propertyId) async {
    return await repository.addToFavorites(propertyId);
  }
}

class RemoveFromFavoritesUsecase {
  final PropertyRepository repository;

  RemoveFromFavoritesUsecase(this.repository);

  Future<Either<String, void>> call(int propertyId) async {
    return await repository.removeFromFavorites(propertyId);
  }
}
