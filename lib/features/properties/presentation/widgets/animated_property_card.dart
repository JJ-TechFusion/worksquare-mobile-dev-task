import 'package:flutter/material.dart';
import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';
import 'package:dreamdwell/features/properties/presentation/widgets/property_card.dart';

class AnimatedPropertyCard extends StatefulWidget {
  final PropertyEntity property;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;
  final int index;

  const AnimatedPropertyCard({
    super.key,
    required this.property,
    this.onFavoriteToggle,
    this.onTap,
    required this.index,
  });

  @override
  State<AnimatedPropertyCard> createState() => _AnimatedPropertyCardState();
}

class _AnimatedPropertyCardState extends State<AnimatedPropertyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation after a small delay based on index
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(1.0),
                child: PropertyCard(
                  property: widget.property,
                  onFavoriteToggle: widget.onFavoriteToggle,
                  onTap: widget.onTap,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
