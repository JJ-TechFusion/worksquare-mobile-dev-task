import 'package:dartz/dartz.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';
import 'package:dreamdwell/features/properties/domain/repositories/property_repository.dart';

class SearchPropertiesParams {
  final String? query;
  final String? location;
  final int? minBedrooms;
  final int? maxBedrooms;
  final String? propertyType;

  const SearchPropertiesParams({
    this.query,
    this.location,
    this.minBedrooms,
    this.maxBedrooms,
    this.propertyType,
  });
}

class SearchPropertiesUsecase {
  final PropertyRepository repository;

  SearchPropertiesUsecase(this.repository);

  Future<Either<String, List<PropertyEntity>>> call(SearchPropertiesParams params) async {
    return await repository.searchProperties(
      query: params.query,
      location: params.location,
      minBedrooms: params.minBedrooms,
      maxBedrooms: params.maxBedrooms,
      propertyType: params.propertyType,
    );
  }
}
