import 'package:dartz/dartz.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';

abstract class PropertyRepository {
  Future<Either<String, List<PropertyEntity>>> getProperties();
  Future<Either<String, PropertyEntity>> getPropertyById(int id);
  Future<Either<String, List<PropertyEntity>>> searchProperties({
    String? query,
    String? location,
    int? minBedrooms,
    int? maxBedrooms,
    String? propertyType,
  });
  Future<Either<String, List<PropertyEntity>>> getFavoriteProperties();
  Future<Either<String, void>> addToFavorites(int propertyId);
  Future<Either<String, void>> removeFromFavorites(int propertyId);
}
