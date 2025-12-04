import 'package:dreamdwell/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';
import 'package:dreamdwell/features/properties/properties.dart';

class PropertyDetailsPage extends StatefulWidget {
  final int propertyId;

  const PropertyDetailsPage({super.key, required this.propertyId});

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyProvider>().loadPropertyById(widget.propertyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PropertyProvider>(
        builder: (context, propertyProvider, child) {
          final state = propertyProvider.state;
          final property = state.selectedProperty;

          if (property == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final isFavorite = state.isPropertyFavorite(property.id);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Property Image
                      Image.asset(
                        'assets/images/${property.image}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.home,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                      // Status Tags
                      Positioned(
                        top: 60,
                        left: 16,
                        child: Row(
                          children:
                              property.status.map((status) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: BodySmall(
                                    status,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, top: 16),
                    child: GestureDetector(
                      onTap: () {
                        propertyProvider.toggleFavorite(property.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Property Details Content
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and Title Section
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H1(property.price, fontSize: 32),
                            const SizedBox(height: 4),
                            BodySmall('Per Annum', color: Colors.grey[600]),
                            const SizedBox(height: 16),

                            BodyText(
                              property.title,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: AppColor.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: BodyText(
                                    property.location,
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Property Features
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFeatureItem(
                              Icons.bed_outlined,
                              '${property.bedrooms}',
                              'Bedrooms',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            _buildFeatureItem(
                              Icons.bathroom_outlined,
                              '${property.bathrooms}',
                              'Bathrooms',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            _buildFeatureItem(
                              Icons.square_foot_outlined,
                              '2,500',
                              'Sq Ft',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Description Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const H3('Description'),
                            const SizedBox(height: 12),
                            BodyText(
                              'This beautiful ${property.bedrooms}-bedroom property offers modern living in the heart of ${property.location}. '
                              'Featuring spacious rooms, contemporary finishes, and excellent amenities. '
                              'Perfect for families looking for comfort and convenience in a prime location. '
                              'The property boasts ${property.bathrooms} well-appointed bathrooms and ample living space throughout.',
                              color: AppColor.lightText,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Amenities Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const H3('Amenities'),
                            _buildAmenitiesGrid(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Contact Section
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColor.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const H3('Interested in this property?'),
                            const SizedBox(height: 8),
                            BodyText(
                              'Contact our agent for more information or to schedule a viewing.',
                              color: Colors.grey[700],
                            ),
                            verticalSpace(16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Calling agent...'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.phone),
                                    label: const Text('Call'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Opening messages...'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.message),
                                    label: const Text('Message'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColor.primary,
                                      side: BorderSide(color: AppColor.primary),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Bottom padding
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColor.primary),
        const SizedBox(height: 8),
        H3(value),
        const SizedBox(height: 4),
        BodySmall(label, color: Colors.grey[600]),
      ],
    );
  }

  Widget _buildAmenitiesGrid() {
    final amenities = [
      'Parking',
      'Security',
      'Garden',
      'Balcony',
      'Air Conditioning',
      'Internet',
      'Furnished',
      'Pet Friendly',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Icon(Icons.check_circle, size: 16, color: AppColor.green),
            const SizedBox(width: 8),
            Expanded(
              child: BodySmall(amenities[index], color: Colors.grey[700]),
            ),
          ],
        );
      },
    );
  }
}
