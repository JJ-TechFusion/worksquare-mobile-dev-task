import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';
import 'package:dreamdwell/core/routes/route_names.dart';
import 'package:dreamdwell/core/routes/route_arguments.dart';
import 'package:dreamdwell/features/properties/properties.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({super.key});

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  List<String> _availableLocations = [];
  List<String> _availablePropertyTypes = [];

  @override
  void initState() {
    super.initState();
    // Load properties when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PropertyProvider>();
      // Clear any existing search state and load fresh properties
      provider.clearSearch();
      provider.loadProperties();
    });
  }

  void _extractFiltersFromProperties(List<PropertyEntity> properties) {
    final locations = <String>{};
    final propertyTypes = <String>{};

    for (final property in properties) {
      locations.add(property.location);
      propertyTypes.addAll(property.status);
    }

    setState(() {
      _availableLocations = locations.toList()..sort();
      _availablePropertyTypes = propertyTypes.toList()..sort();
    });
  }

  void _onSearch(String query, String? location, String? propertyType) {
    context.read<PropertyProvider>().searchAndFilterProperties(
      query: query.isEmpty ? null : query,
      location: location,
      propertyType: propertyType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const H2('Properties'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<PropertyProvider>(
        builder: (context, propertyProvider, child) {
          final state = propertyProvider.state;

          // Extract filters when properties are loaded
          if (state.hasProperties && _availableLocations.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _extractFiltersFromProperties(state.properties);
            });
          }

          return Column(
            children: [
              // Search and Filter Bar
              if (state.hasProperties || state.isLoading)
                SearchFilterBar(
                  onSearch: _onSearch,
                  availableLocations: _availableLocations,
                  availablePropertyTypes: _availablePropertyTypes,
                ),
              
              // Results Counter
              if (state.hasProperties)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: BodySmall(
                    '${state.properties.length} ${state.properties.length == 1 ? 'property' : 'properties'} found',
                    color: Colors.grey[600],
                  ),
                ),
              
              // Content Area
              Expanded(
                child: _buildContent(state, propertyProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(PropertyState state, PropertyProvider propertyProvider) {
    if (state.isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 3, // Show 3 shimmer items
        itemBuilder: (context, index) => const PropertyShimmer(),
      );
    }

    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColor.errorColor,
            ),
            const SizedBox(height: 16),
            BodyText(
              state.errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                propertyProvider.loadProperties();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!state.hasProperties) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                state.isSearching ? Icons.search_off : Icons.home_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              H3(
                state.isSearching 
                    ? 'No properties match your search'
                    : 'No properties found',
                textAlign: TextAlign.center,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 12),
              BodyText(
                state.isSearching
                    ? 'Try adjusting your search criteria or clear filters to see all properties'
                    : 'Properties will appear here when available',
                textAlign: TextAlign.center,
                color: Colors.grey[500],
              ),
              if (state.isSearching) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      propertyProvider.clearSearch();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Show All Properties'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: state.properties.length,
      itemBuilder: (context, index) {
        final property = state.properties[index];

        return AnimatedPropertyCard(
          property: property,
          index: index,
          onFavoriteToggle: () {
            propertyProvider.toggleFavorite(property.id);
          },
          onTap: () {
            Navigator.of(context).pushNamed(
              RouteNames.propertyDetails,
              arguments: PropertyDetailsArguments(
                propertyId: property.id,
              ),
            );
          },
        );
      },
    );
  }
}
