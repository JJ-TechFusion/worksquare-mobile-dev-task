import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';

enum PropertyStatus { initial, loading, loaded, error }

class PropertyState {
  final PropertyStatus status;
  final List<PropertyEntity> properties;
  final List<PropertyEntity> favoriteProperties;
  final PropertyEntity? selectedProperty;
  final String? errorMessage;
  final bool isSearching;
  final String? searchQuery;
  final String? selectedLocation;
  final String? selectedPropertyType;

  const PropertyState({
    this.status = PropertyStatus.initial,
    this.properties = const [],
    this.favoriteProperties = const [],
    this.selectedProperty,
    this.errorMessage,
    this.isSearching = false,
    this.searchQuery,
    this.selectedLocation,
    this.selectedPropertyType,
  });

  PropertyState copyWith({
    PropertyStatus? status,
    List<PropertyEntity>? properties,
    List<PropertyEntity>? favoriteProperties,
    PropertyEntity? selectedProperty,
    String? errorMessage,
    bool? isSearching,
    String? searchQuery,
    String? selectedLocation,
    String? selectedPropertyType,
    bool clearSelectedProperty = false,
    bool clearError = false,
  }) {
    return PropertyState(
      status: status ?? this.status,
      properties: properties ?? this.properties,
      favoriteProperties: favoriteProperties ?? this.favoriteProperties,
      selectedProperty: clearSelectedProperty ? null : (selectedProperty ?? this.selectedProperty),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedPropertyType: selectedPropertyType ?? this.selectedPropertyType,
    );
  }

  bool get isLoading => status == PropertyStatus.loading;
  bool get hasError => status == PropertyStatus.error && errorMessage != null;
  bool get hasProperties => properties.isNotEmpty;
  bool get hasFavorites => favoriteProperties.isNotEmpty;

  bool isPropertyFavorite(int propertyId) {
    return favoriteProperties.any((property) => property.id == propertyId);
  }

  @override
  String toString() {
    return 'PropertyState{status: $status, properties: ${properties.length}, favorites: ${favoriteProperties.length}, error: $errorMessage}';
  }
}
