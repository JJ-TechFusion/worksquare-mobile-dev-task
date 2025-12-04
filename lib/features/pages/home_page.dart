import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/routes/route_names.dart';
import 'package:dreamdwell/core/routes/route_arguments.dart';
import 'package:dreamdwell/core/utils/constant.dart';
import 'package:dreamdwell/core/utils/toast_helper.dart';
import 'package:dreamdwell/features/properties/properties.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load properties when the page initializes
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
          child: const BodyText(''),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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

          if (state.status == PropertyStatus.loading) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Show 5 shimmer items
              itemBuilder: (context, index) => const PropertyShimmer(),
            );
          }

          if (state.properties.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home_outlined, size: 80, color: Colors.grey),
                  verticalSpace(16),
                  const H3('No properties available', color: Colors.grey),
                  verticalSpace(16),
                  ElevatedButton(
                    onPressed: () {
                      propertyProvider.loadProperties();
                    },
                    child: const BodyText('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H2('Find Your Dream Home'),
                    verticalSpace(8),
                    BodyText(
                      'Discover ${state.properties.length} amazing properties',
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),

              // Properties list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
          );
        },
      ),
    );
  }
}
