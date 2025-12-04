import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dreamdwell/core/services/network/network_response.dart';
import '../../utils/constant.dart';

class ApiService {
  ApiService();

  Future<NetworkResponse> getRequest({
    String? endpoint,
    Map<String, dynamic>? query,
  }) async {
    try {
      logMessage(
        'ApiService',
        'Simulating GET request to $endpoint with query: $query',
      );

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final String responseString =
          await rootBundle.loadString('assets/data/properties.json');
      final Map<String, dynamic> responseData = json.decode(responseString);

      return NetworkResponse(
        message: responseData['message'] ?? 'Data fetched successfully',
        success: responseData['success'] ?? true,
        data: responseData['data'],
        statusCode: responseData['statusCode'] ?? 200,
      );
    } catch (e) {
      logMessage('ApiService', 'Error simulating GET request: $e');
      return NetworkResponse(
        success: false,
        message: 'Failed to load data from local JSON: $e',
        data: null,
        statusCode: 500,
      );
    }
  }

  // Simplified methods for local JSON usage
  Future<NetworkResponse> postRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    Object? requestBody,
  }) async {
    logMessage(
      'ApiService',
      'Simulating POST request to $endpoint with body: $requestBody',
    );
    await Future.delayed(const Duration(milliseconds: 300));
    return NetworkResponse(
      message: 'Operation successful (simulated)',
      success: true,
      data: requestBody,
      statusCode: 200,
    );
  }

  Future<NetworkResponse> putRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    Object? requestBody,
  }) async {
    logMessage(
      'ApiService',
      'Simulating PUT request to $endpoint with body: $requestBody',
    );
    await Future.delayed(const Duration(milliseconds: 300));
    return NetworkResponse(
      message: 'Operation successful (simulated)',
      success: true,
      data: requestBody,
      statusCode: 200,
    );
  }

  Future<NetworkResponse> patchRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    Object? requestBody,
  }) async {
    logMessage(
      'ApiService',
      'Simulating PATCH request to $endpoint with body: $requestBody',
    );
    await Future.delayed(const Duration(milliseconds: 300));
    return NetworkResponse(
      message: 'Operation successful (simulated)',
      success: true,
      data: requestBody,
      statusCode: 200,
    );
  }

  Future<NetworkResponse> deleteRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    Object? requestBody,
  }) async {
    logMessage(
      'ApiService',
      'Simulating DELETE request to $endpoint with body: $requestBody',
    );
    await Future.delayed(const Duration(milliseconds: 300));
    return NetworkResponse(
      message: 'Operation successful (simulated)',
      success: true,
      data: null,
      statusCode: 200,
    );
  }

  Future<NetworkResponse> requestWithFile({
    String? endpoint,
    Map<String, dynamic>? query,
    String fileName = '',
    dynamic mimeType,
    List<int> fileBytes = const [],
    Object? otherFieldsInRequest,
  }) async {
    logMessage(
      'ApiService',
      'Simulating file upload to $endpoint with file: $fileName',
    );
    await Future.delayed(const Duration(milliseconds: 500));
    return NetworkResponse(
      message: 'File upload successful (simulated)',
      success: true,
      data: null,
      statusCode: 200,
    );
  }

  Future<NetworkResponse> submitKycFormData({
    required String endpoint,
    required Map<String, dynamic> formData,
  }) async {
    logMessage(
      'ApiService',
      'Simulating KYC form submission to $endpoint with data: $formData',
    );
    await Future.delayed(const Duration(milliseconds: 500));
    return NetworkResponse(
      message: 'KYC form submission successful (simulated)',
      success: true,
      data: null,
      statusCode: 200,
    );
  }
}