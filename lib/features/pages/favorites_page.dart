import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';
import 'package:dreamdwell/core/routes/route_names.dart';
import 'package:dreamdwell/core/routes/route_arguments.dart';
import 'package:dreamdwell/features/properties/properties.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PropertyProvider>();
      provider.loadProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const H2('Favorites'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<PropertyProvider>(
        builder: (context, propertyProvider, child) {
          final state = propertyProvider.state;

          if (state.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 2, // Show 2 shimmer items
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

          if (!state.hasFavorites) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    H3(
                      'No Favorites Yet',
                      textAlign: TextAlign.center,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 12),
                    BodyText(
                      'Properties you favorite will appear here for easy access',
                      textAlign: TextAlign.center,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to home tab to browse properties
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(RouteNames.main);
                        },
                        icon: const Icon(Icons.search),
                        label: const Text('Browse Properties'),
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
                ),
              ),
            );
          }

          return Column(
            children: [
              // Favorites Counter
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(Icons.favorite, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    BodyText(
                      '${state.favoriteProperties.length} ${state.favoriteProperties.length == 1 ? 'property' : 'properties'} saved',
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    if (state.favoriteProperties.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          _showClearAllDialog(context, propertyProvider);
                        },
                        child: BodySmall('Clear All', color: Colors.red),
                      ),
                  ],
                ),
              ),

              // Favorites List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.favoriteProperties.length,
                  itemBuilder: (context, index) {
                    final property = state.favoriteProperties[index];

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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearAllDialog(
    BuildContext context,
    PropertyProvider propertyProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const H3('Clear All Favorites'),
          content: const BodyText(
            'Are you sure you want to remove all properties from your favorites? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear all favorites
                for (final property
                    in propertyProvider.state.favoriteProperties) {
                  propertyProvider.toggleFavorite(property.id);
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}
