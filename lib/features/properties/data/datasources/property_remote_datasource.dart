import 'package:dreamdwell/core/services/network/api_services.dart';
import 'package:dreamdwell/core/services/network/network_response.dart';

abstract class PropertyRemoteDataSource {
  Future<NetworkResponse> getProperties();
  Future<NetworkResponse> getPropertyById(int id);
  Future<NetworkResponse> searchProperties({
    String? query,
    String? location,
    int? minBedrooms,
    int? maxBedrooms,
    String? propertyType,
  });
}

class PropertyRemoteDataSourceImpl implements PropertyRemoteDataSource {
  final ApiService apiService;

  PropertyRemoteDataSourceImpl({required this.apiService});

  @override
  Future<NetworkResponse> getProperties() async {
    return await apiService.getRequest(
      endpoint: '/properties',
    );
  }

  @override
  Future<NetworkResponse> getPropertyById(int id) async {
    return await apiService.getRequest(
      endpoint: '/properties/$id',
    );
  }

  @override
  Future<NetworkResponse> searchProperties({
    String? query,
    String? location,
    int? minBedrooms,
    int? maxBedrooms,
    String? propertyType,
  }) async {
    final Map<String, dynamic> queryParams = {};
    
    if (query != null) queryParams['query'] = query;
    if (location != null) queryParams['location'] = location;
    if (minBedrooms != null) queryParams['minBedrooms'] = minBedrooms.toString();
    if (maxBedrooms != null) queryParams['maxBedrooms'] = maxBedrooms.toString();
    if (propertyType != null) queryParams['propertyType'] = propertyType;

    return await apiService.getRequest(
      endpoint: '/properties/search',
      query: queryParams,
    );
  }
}
