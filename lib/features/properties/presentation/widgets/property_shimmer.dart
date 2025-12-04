import 'package:flutter/material.dart';

class PropertyShimmer extends StatefulWidget {
  const PropertyShimmer({super.key});

  @override
  State<PropertyShimmer> createState() => _PropertyShimmerState();
}

class _PropertyShimmerState extends State<PropertyShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
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
              // Image shimmer
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.grey[300]!,
                      Colors.grey[100]!,
                      Colors.grey[300]!,
                    ],
                    stops: [
                      _animation.value - 1,
                      _animation.value,
                      _animation.value + 1,
                    ],
                  ),
                ),
              ),
              // Content shimmer
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price shimmer
                    _buildShimmerBox(120, 32),
                    const SizedBox(height: 8),
                    _buildShimmerBox(80, 16),
                    const SizedBox(height: 16),
                    // Features shimmer
                    Row(
                      children: [
                        _buildShimmerBox(80, 16),
                        const SizedBox(width: 24),
                        _buildShimmerBox(90, 16),
                        const SizedBox(width: 24),
                        _buildShimmerBox(100, 16),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Title shimmer
                    _buildShimmerBox(double.infinity, 20),
                    const SizedBox(height: 8),
                    _buildShimmerBox(200, 20),
                    const SizedBox(height: 20),
                    // Button shimmer
                    _buildShimmerBox(double.infinity, 50),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: [
            _animation.value - 1,
            _animation.value,
            _animation.value + 1,
          ],
        ),
      ),
    );
  }
}
