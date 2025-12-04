import 'package:dartz/dartz.dart';
import 'package:dreamdwell/core/utils/constant.dart';
import 'package:dreamdwell/features/properties/data/datasources/property_local_datasource.dart';
import 'package:dreamdwell/features/properties/data/datasources/property_remote_datasource.dart';
import 'package:dreamdwell/features/properties/data/models/property_model.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';
import 'package:dreamdwell/features/properties/domain/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource remoteDataSource;
  final PropertyLocalDataSource localDataSource;

  PropertyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, List<PropertyEntity>>> getProperties() async {
    try {
      final cachedProperties = await localDataSource.getCachedProperties();
      if (cachedProperties.isNotEmpty) {
        logMessage(
          'PropertyRepository',
          'Returning cached properties: ${cachedProperties.length}',
        );
        return Right(
          cachedProperties.map((model) => model.toEntity()).toList(),
        );
      }

      final response = await remoteDataSource.getProperties();

      if (response.success && response.data != null) {
        final List<dynamic> propertiesJson = response.data as List<dynamic>;
        final properties =
            propertiesJson
                .map(
                  (json) =>
                      PropertyModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();

        await localDataSource.cacheProperties(properties);

        logMessage(
          'PropertyRepository',
          'Fetched ${properties.length} properties from remote',
        );
        return Right(properties.map((model) => model.toEntity()).toList());
      } else {
        return Left(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to fetch properties',
        );
      }
    } catch (e) {
      logMessage('PropertyRepository', 'Error fetching properties: $e');
      return Left('Failed to fetch properties: $e');
    }
  }

  @override
  Future<Either<String, PropertyEntity>> getPropertyById(int id) async {
    try {
      final cachedProperty = await localDataSource.getCachedPropertyById(id);
      if (cachedProperty != null) {
        logMessage('PropertyRepository', 'Returning cached property: $id');
        return Right(cachedProperty.toEntity());
      }

      final propertiesResult = await getProperties();
      return propertiesResult.fold((error) => Left(error), (properties) {
        try {
          final property = properties.firstWhere((p) => p.id == id);
          return Right(property);
        } catch (e) {
          return Left('Property with id $id not found');
        }
      });
    } catch (e) {
      logMessage('PropertyRepository', 'Error fetching property by id: $e');
      return Left('Failed to fetch property: $e');
    }
  }

  @override
  Future<Either<String, List<PropertyEntity>>> searchProperties({
    String? query,
    String? location,
    int? minBedrooms,
    int? maxBedrooms,
    String? propertyType,
  }) async {
    try {
      final propertiesResult = await getProperties();

      return propertiesResult.fold((error) => Left(error), (properties) {
        List<PropertyEntity> filteredProperties = properties;

        if (query != null && query.isNotEmpty) {
          filteredProperties =
              filteredProperties
                  .where(
                    (property) =>
                        property.title.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        property.location.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                  )
                  .toList();
        }

        if (location != null && location.isNotEmpty) {
          filteredProperties =
              filteredProperties
                  .where(
                    (property) => property.location.toLowerCase().contains(
                      location.toLowerCase(),
                    ),
                  )
                  .toList();
        }

        if (minBedrooms != null) {
          filteredProperties =
              filteredProperties
                  .where((property) => property.bedrooms >= minBedrooms)
                  .toList();
        }

        if (maxBedrooms != null) {
          filteredProperties =
              filteredProperties
                  .where((property) => property.bedrooms <= maxBedrooms)
                  .toList();
        }

        if (propertyType != null && propertyType.isNotEmpty) {
          filteredProperties =
              filteredProperties
                  .where(
                    (property) => property.status.any(
                      (status) => status.toLowerCase().contains(
                        propertyType.toLowerCase(),
                      ),
                    ),
                  )
                  .toList();
        }

        logMessage(
          'PropertyRepository',
          'Search returned ${filteredProperties.length} properties',
        );
        return Right(filteredProperties);
      });
    } catch (e) {
      logMessage('PropertyRepository', 'Error searching properties: $e');
      return Left('Failed to search properties: $e');
    }
  }

  @override
  Future<Either<String, List<PropertyEntity>>> getFavoriteProperties() async {
    try {
      final favoriteIds = await localDataSource.getFavoritePropertyIds();
      final propertiesResult = await getProperties();

      return propertiesResult.fold((error) => Left(error), (properties) {
        final favoriteProperties =
            properties
                .where((property) => favoriteIds.contains(property.id))
                .map((property) => property.copyWith(isFavorite: true))
                .toList();

        logMessage(
          'PropertyRepository',
          'Returning ${favoriteProperties.length} favorite properties',
        );
        return Right(favoriteProperties);
      });
    } catch (e) {
      logMessage(
        'PropertyRepository',
        'Error fetching favorite properties: $e',
      );
      return Left('Failed to fetch favorite properties: $e');
    }
  }

  @override
  Future<Either<String, void>> addToFavorites(int propertyId) async {
    try {
      await localDataSource.addToFavorites(propertyId);
      logMessage(
        'PropertyRepository',
        'Added property $propertyId to favorites',
      );
      return const Right(null);
    } catch (e) {
      logMessage('PropertyRepository', 'Error adding to favorites: $e');
      return Left('Failed to add to favorites: $e');
    }
  }

  @override
  Future<Either<String, void>> removeFromFavorites(int propertyId) async {
    try {
      await localDataSource.removeFromFavorites(propertyId);
      logMessage(
        'PropertyRepository',
        'Removed property $propertyId from favorites',
      );
      return const Right(null);
    } catch (e) {
      logMessage('PropertyRepository', 'Error removing from favorites: $e');
      return Left('Failed to remove from favorites: $e');
    }
  }
}
