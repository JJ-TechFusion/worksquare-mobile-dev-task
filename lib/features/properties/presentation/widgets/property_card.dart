import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';

class PropertyCard extends StatelessWidget {
  final PropertyEntity property;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.onFavoriteToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image with Status Tags and Favorite Button
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/${property.image}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.home,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Status Tags (Top Left)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: property.status.map((status) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: BodySmall(
                          status,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Favorite Button (Top Right)
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
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
                        property.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: property.isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Property Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Per Annum
                  Row(
                    children: [
                      H1(
                        property.price,
                        fontSize: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  BodyText(
                    'Per Annum',
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  // Property Features (Bedrooms, Bathrooms, Location)
                  Row(
                    children: [
                      _buildFeature(
                        Icons.bed_outlined,
                        '${property.bedrooms} Bedroom',
                      ),
                      const SizedBox(width: 24),
                      _buildFeature(
                        Icons.bathroom_outlined,
                        '${property.bathrooms} Bathroom',
                      ),
                      const SizedBox(width: 24),
                      _buildFeature(
                        Icons.location_on_outlined,
                        property.location,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Property Title
                  BodyText(
                    property.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 20),
                  // View Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BodyText(
                            'View Details',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[700],
        ),
        const SizedBox(width: 6),
        BodySmall(
          text,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
