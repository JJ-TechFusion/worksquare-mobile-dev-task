import 'package:flutter/material.dart';
import 'package:dreamdwell/core/utils/constant.dart';
import 'package:dreamdwell/core/utils/no_params.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';
import 'package:dreamdwell/features/properties/domain/usecases/get_properties_usecase.dart';
import 'package:dreamdwell/features/properties/domain/usecases/get_property_by_id_usecase.dart';
import 'package:dreamdwell/features/properties/domain/usecases/search_properties_usecase.dart';
import 'package:dreamdwell/features/properties/domain/usecases/manage_favorites_usecase.dart';
import 'package:dreamdwell/features/properties/presentation/providers/property_state.dart';

class PropertyProvider extends ChangeNotifier {
  final GetPropertiesUsecase _getPropertiesUsecase;
  final GetPropertyByIdUsecase _getPropertyByIdUsecase;
  final SearchPropertiesUsecase _searchPropertiesUsecase;
  final GetFavoritePropertiesUsecase _getFavoritePropertiesUsecase;
  final AddToFavoritesUsecase _addToFavoritesUsecase;
  final RemoveFromFavoritesUsecase _removeFromFavoritesUsecase;

  PropertyState _state = const PropertyState();
  PropertyState get state => _state;

  PropertyProvider({
    required GetPropertiesUsecase getPropertiesUsecase,
    required GetPropertyByIdUsecase getPropertyByIdUsecase,
    required SearchPropertiesUsecase searchPropertiesUsecase,
    required GetFavoritePropertiesUsecase getFavoritePropertiesUsecase,
    required AddToFavoritesUsecase addToFavoritesUsecase,
    required RemoveFromFavoritesUsecase removeFromFavoritesUsecase,
  })  : _getPropertiesUsecase = getPropertiesUsecase,
        _getPropertyByIdUsecase = getPropertyByIdUsecase,
        _searchPropertiesUsecase = searchPropertiesUsecase,
        _getFavoritePropertiesUsecase = getFavoritePropertiesUsecase,
        _addToFavoritesUsecase = addToFavoritesUsecase,
        _removeFromFavoritesUsecase = removeFromFavoritesUsecase;

  void _updateState(PropertyState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadProperties() async {
    _updateState(_state.copyWith(status: PropertyStatus.loading, clearError: true));

    try {
      final result = await _getPropertiesUsecase(NoParams());
      
      result.fold(
        (error) {
          logMessage('PropertyProvider', 'Error loading properties: $error');
          _updateState(_state.copyWith(
            status: PropertyStatus.error,
            errorMessage: error,
          ));
        },
        (properties) async {
          logMessage('PropertyProvider', 'Loaded ${properties.length} properties');
          
          // Get favorite IDs and update properties with favorite status
          final favoriteResult = await _getFavoritePropertiesUsecase();
          favoriteResult.fold(
            (error) {
              logMessage('PropertyProvider', 'Error loading favorites: $error');
              // Continue with properties without favorite status
              _updateState(_state.copyWith(
                status: PropertyStatus.loaded,
                properties: properties,
                favoriteProperties: [],
              ));
            },
            (favoriteProperties) {
              // Update main properties with favorite status
              final favoriteIds = favoriteProperties.map((p) => p.id).toSet();
              final updatedProperties = properties.map((property) {
                return property.copyWith(isFavorite: favoriteIds.contains(property.id));
              }).toList();
              
              // Ensure all favorite properties have isFavorite: true
              final updatedFavoriteProperties = favoriteProperties.map((property) {
                return property.copyWith(isFavorite: true);
              }).toList();
              
              _updateState(_state.copyWith(
                status: PropertyStatus.loaded,
                properties: updatedProperties,
                favoriteProperties: updatedFavoriteProperties,
              ));
            },
          );
        },
      );
    } catch (e) {
      logMessage('PropertyProvider', 'Exception loading properties: $e');
      _updateState(_state.copyWith(
        status: PropertyStatus.error,
        errorMessage: 'Failed to load properties: $e',
      ));
    }
  }

  Future<void> loadPropertyById(int id) async {
    _updateState(_state.copyWith(clearSelectedProperty: true));

    try {
      final result = await _getPropertyByIdUsecase(id);
      
      result.fold(
        (error) {
          logMessage('PropertyProvider', 'Error loading property $id: $error');
          _updateState(_state.copyWith(errorMessage: error));
        },
        (property) {
          logMessage('PropertyProvider', 'Loaded property: ${property.title}');
          _updateState(_state.copyWith(selectedProperty: property));
        },
      );
    } catch (e) {
      logMessage('PropertyProvider', 'Exception loading property $id: $e');
      _updateState(_state.copyWith(errorMessage: 'Failed to load property: $e'));
    }
  }

  Future<void> searchAndFilterProperties({
    String? query,
    String? location,
    String? propertyType,
  }) async {
    _updateState(_state.copyWith(
      isSearching: true,
      searchQuery: query,
      selectedLocation: location,
      selectedPropertyType: propertyType,
      clearError: true,
    ));

    try {
      final params = SearchPropertiesParams(
        query: query,
        location: location,
        propertyType: propertyType,
      );

      final result = await _searchPropertiesUsecase(params);
      
      result.fold(
        (error) {
          logMessage('PropertyProvider', 'Error searching properties: $error');
          _updateState(_state.copyWith(
            isSearching: false,
            errorMessage: error,
          ));
        },
        (properties) {
          logMessage('PropertyProvider', 'Search found ${properties.length} properties');
          _updateState(_state.copyWith(
            isSearching: false,
            properties: properties,
            status: PropertyStatus.loaded,
          ));
        },
      );
    } catch (e) {
      logMessage('PropertyProvider', 'Exception searching properties: $e');
      _updateState(_state.copyWith(
        isSearching: false,
        errorMessage: 'Failed to search properties: $e',
      ));
    }
  }


  Future<void> toggleFavorite(int propertyId) async {
    final isFavorite = _state.isPropertyFavorite(propertyId);
    
    try {
      if (isFavorite) {
        final result = await _removeFromFavoritesUsecase(propertyId);
        result.fold(
          (error) {
            logMessage('PropertyProvider', 'Error removing favorite: $error');
            _updateState(_state.copyWith(errorMessage: error));
          },
          (_) {
            logMessage('PropertyProvider', 'Removed property $propertyId from favorites');
            _updateFavoriteStatus(propertyId, false);
          },
        );
      } else {
        final result = await _addToFavoritesUsecase(propertyId);
        result.fold(
          (error) {
            logMessage('PropertyProvider', 'Error adding favorite: $error');
            _updateState(_state.copyWith(errorMessage: error));
          },
          (_) {
            logMessage('PropertyProvider', 'Added property $propertyId to favorites');
            _updateFavoriteStatus(propertyId, true);
          },
        );
      }
    } catch (e) {
      logMessage('PropertyProvider', 'Exception toggling favorite: $e');
      _updateState(_state.copyWith(errorMessage: 'Failed to update favorites: $e'));
    }
  }

  void _updateFavoriteStatus(int propertyId, bool isFavorite) {
    // Update the main properties list
    final updatedProperties = _state.properties.map((property) {
      if (property.id == propertyId) {
        return property.copyWith(isFavorite: isFavorite);
      }
      return property;
    }).toList();

    // Update the favorites list
    List<PropertyEntity> updatedFavorites;
    if (isFavorite) {
      // Add to favorites if not already there
      try {
        final propertyToAdd = _state.properties.firstWhere((p) => p.id == propertyId);
        updatedFavorites = [..._state.favoriteProperties];
        if (!updatedFavorites.any((p) => p.id == propertyId)) {
          updatedFavorites.add(propertyToAdd.copyWith(isFavorite: true));
        }
      } catch (e) {
        // Property not found in main list, skip adding to favorites
        updatedFavorites = _state.favoriteProperties;
      }
    } else {
      // Remove from favorites
      updatedFavorites = _state.favoriteProperties.where((p) => p.id != propertyId).toList();
    }

    _updateState(_state.copyWith(
      properties: updatedProperties,
      favoriteProperties: updatedFavorites,
    ));
  }

  void clearError() {
    _updateState(_state.copyWith(clearError: true));
  }

  void clearSelectedProperty() {
    _updateState(_state.copyWith(clearSelectedProperty: true));
  }

  void clearSearch() {
    _updateState(_state.copyWith(
      searchQuery: null,
      isSearching: false,
    ));
    // Reload all properties
    loadProperties();
  }

  void clearSearchAndFilters() {
    _updateState(_state.copyWith(
      searchQuery: null,
      selectedLocation: null,
      selectedPropertyType: null,
      isSearching: false,
    ));
    // Reload all properties
    loadProperties();
  }
}
