import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/shared/widgets/smart_image.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';
import 'package:dreamdwell/core/utils/constant.dart';

class OnboardingPage extends StatelessWidget {
  final Color? color;
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    this.color,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const double horizontalSpacing = 20;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: const EdgeInsets.only(
        left: horizontalSpacing,
        right: horizontalSpacing,
      ),
      color: color, // BackgroundColor
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: isLandscape ? 200 : 300,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SmartImage(
                imageUrl: image,
                fit: BoxFit.cover,
                fallbackIcon: _getIconForImage(image),
                fallbackIconSize: 80,
                progressStrokeWidth: 3,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          verticalSpace(isLandscape ? 20 : 40),

          Center(
            child: H2(
              title,
              textAlign: TextAlign.center,
              fontSize: isLandscape ? 20 : null,
            ),
          ),
          verticalSpace(10),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BodyText(
                subtitle,
                textAlign: TextAlign.center,
                color: AppColor.lightText,
                fontSize: isLandscape ? 16 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForImage(String image) {
    switch (image) {
      case 'onboard1':
        return Icons.search;
      case 'onboard2':
        return Icons.favorite;
      case 'onboard3':
        return Icons.home;
      default:
        return Icons.home;
    }
  }
}
