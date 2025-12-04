import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/responsive_helper.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: ResponsiveHelper.getResponsivePadding(context),
                viewPadding: ResponsiveHelper.getResponsivePadding(context),
              ),
              child: child,
            );
          },
        );
      },
    );
  }
}
