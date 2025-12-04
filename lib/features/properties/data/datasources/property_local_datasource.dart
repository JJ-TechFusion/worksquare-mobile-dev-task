import 'package:dreamdwell/features/properties/data/models/property_model.dart';

abstract class PropertyLocalDataSource {
  Future<List<PropertyModel>> getCachedProperties();
  Future<void> cacheProperties(List<PropertyModel> properties);
  Future<PropertyModel?> getCachedPropertyById(int id);
  Future<List<int>> getFavoritePropertyIds();
  Future<void> addToFavorites(int propertyId);
  Future<void> removeFromFavorites(int propertyId);
  Future<void> clearCache();
}

class PropertyLocalDataSourceImpl implements PropertyLocalDataSource {
  List<PropertyModel> _cachedProperties = [];
  final Set<int> _favoriteIds = {};

  @override
  Future<List<PropertyModel>> getCachedProperties() async {
    return _cachedProperties;
  }

  @override
  Future<void> cacheProperties(List<PropertyModel> properties) async {
    _cachedProperties = properties;
  }

  @override
  Future<PropertyModel?> getCachedPropertyById(int id) async {
    try {
      return _cachedProperties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<int>> getFavoritePropertyIds() async {
    return _favoriteIds.toList();
  }

  @override
  Future<void> addToFavorites(int propertyId) async {
    _favoriteIds.add(propertyId);
  }

  @override
  Future<void> removeFromFavorites(int propertyId) async {
    _favoriteIds.remove(propertyId);
  }

  @override
  Future<void> clearCache() async {
    _cachedProperties.clear();
    _favoriteIds.clear();
  }
}
