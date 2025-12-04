import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/routes/route_names.dart';
import 'package:dreamdwell/core/routes/route_arguments.dart';
import 'package:dreamdwell/core/utils/constant.dart';
import 'package:dreamdwell/core/utils/toast_helper.dart';
import 'package:dreamdwell/features/properties/properties.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PropertyProvider>(context, listen: false).loadProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: const BodyText('Search Properties'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Consumer<PropertyProvider>(
        builder: (context, propertyProvider, child) {
          final state = propertyProvider.state;

          if (state.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ToastMessage.showErrorToast(message: state.errorMessage!);
              propertyProvider.clearError();
            });
          }

          return Column(
            children: [
              SearchFilterBar(
                onSearch: (query, location, propertyType) {
                  propertyProvider.searchAndFilterProperties(
                    query: query,
                    location: location,
                    propertyType: propertyType,
                  );
                },
                availableLocations: _extractUniqueLocations(state.properties),
                availablePropertyTypes: _extractUniquePropertyTypes(
                  state.properties,
                ),
              ),
              if (state.status == PropertyStatus.loading)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5, // Show 5 shimmer items
                    itemBuilder: (context, index) => const PropertyShimmer(),
                  ),
                )
              else if (state.properties.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey,
                        ),
                        verticalSpace(16),
                        const H3('No properties found', color: Colors.grey),
                        verticalSpace(16),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: BodySmall(
                          '${state.properties.length} properties found',
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.properties.length,
                          itemBuilder: (context, index) {
                            final property = state.properties[index];
                            return AnimatedPropertyCard(
                              property: property,
                              index: index,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  RouteNames.propertyDetails,
                                  arguments: PropertyDetailsArguments(
                                    propertyId: property.id,
                                  ),
                                );
                              },
                              onFavoriteToggle: () {
                                propertyProvider.toggleFavorite(property.id);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<String> _extractUniqueLocations(List<PropertyEntity> properties) {
    return properties.map((p) => p.location).toSet().toList()..sort();
  }

  List<String> _extractUniquePropertyTypes(List<PropertyEntity> properties) {
    return properties
        .expand((p) => p.status)
        .map((s) => s.split(' ').first) // Take first word for type
        .toSet()
        .toList()
      ..sort();
  }
}
