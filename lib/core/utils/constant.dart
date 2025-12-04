import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dreamdwell/core/services/network/api_services.dart';
import 'package:dreamdwell/features/properties/properties.dart';

final getIt = GetIt.instance;

verticalSpace(double height) {
  return SizedBox(height: height);
}

horizontalSpace(double width) {
  return SizedBox(width: width);
}

String formatCurrency(String amount) {
  return "₦${amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')}";
}

initDependencies() async {
  // Core services
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(),
  );

  // Property feature dependencies
  // Data sources
  getIt.registerLazySingleton<PropertyLocalDataSource>(
    () => PropertyLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<PropertyRemoteDataSource>(
    () => PropertyRemoteDataSourceImpl(apiService: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<PropertyRepository>(
    () => PropertyRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetPropertiesUsecase>(
    () => GetPropertiesUsecase(getIt()),
  );
  getIt.registerLazySingleton<GetPropertyByIdUsecase>(
    () => GetPropertyByIdUsecase(getIt()),
  );
  getIt.registerLazySingleton<SearchPropertiesUsecase>(
    () => SearchPropertiesUsecase(getIt()),
  );
  getIt.registerLazySingleton<GetFavoritePropertiesUsecase>(
    () => GetFavoritePropertiesUsecase(getIt()),
  );
  getIt.registerLazySingleton<AddToFavoritesUsecase>(
    () => AddToFavoritesUsecase(getIt()),
  );
  getIt.registerLazySingleton<RemoveFromFavoritesUsecase>(
    () => RemoveFromFavoritesUsecase(getIt()),
  );

  // Provider
  getIt.registerLazySingleton<PropertyProvider>(
    () => PropertyProvider(
      getPropertiesUsecase: getIt(),
      getPropertyByIdUsecase: getIt(),
      searchPropertiesUsecase: getIt(),
      getFavoritePropertiesUsecase: getIt(),
      addToFavoritesUsecase: getIt(),
      removeFromFavoritesUsecase: getIt(),
    ),
  );

  await GoogleFonts.pendingFonts([
    GoogleFonts.dmSans(),
    GoogleFonts.dmSans(),
  ]).timeout(const Duration(seconds: 10), onTimeout: () => []);
}

void setupLocator(GlobalKey<NavigatorState> navigatorKey) {}

logMessage(String messageSource, String message, {StackTrace? stackTrace}) {
  log(
    "=========> Message from $messageSource ====================> \n \n =========> Message: $message",
  );
  if (stackTrace != null) {
    debugPrintStack(stackTrace: stackTrace);
  }
}

// Pin themes removed - not needed without authentication