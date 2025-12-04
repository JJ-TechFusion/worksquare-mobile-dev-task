import 'package:dreamdwell/core/shared/widgets/buttons/animated_button.dart';
import 'package:dreamdwell/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:dreamdwell/core/utils/constant.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';
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
                    children:
                        property.status.map((status) {
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
                        property.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
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
                  Row(children: [H1(property.price, fontSize: 28)]),
                  verticalSpace(4),
                  BodyText('Per Annum', color: Colors.grey[600]),
                  verticalSpace(16),
                  Row(
                    spacing: 12,
                    children: [
                      _buildFeature(
                        Icons.bed_outlined,
                        '${property.bedrooms} Bedroom',
                      ),
                      _buildFeature(
                        Icons.bathroom_outlined,
                        '${property.bathrooms} Bathroom',
                      ),
                      _buildFeature(
                        Icons.location_on_outlined,
                        property.location,
                      ),
                    ],
                  ),
                  verticalSpace(14),

                  // Property Title
                  BodyText(
                    property.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                  ),
                  verticalSpace(14),

                  // View Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AnimatedButton(
                      onTap: onTap,
                      child: CustomButton(
                        title: 'View',
                        color: AppColor.primary,
                        textColor: Colors.white,
                        borderRadius: 12,
                        icon: Icons.arrow_forward,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        Icon(icon, size: 12, color: Colors.blueGrey),
        Caption(text, color: Colors.grey[700], fontWeight: FontWeight.w500),
      ],
    );
  }
}
