import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/routes/route_names.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _navigateToOnboarding();
    });
  }

  void _navigateToOnboarding() {
    if (!mounted) return;
    
    Navigator.of(context).pushReplacementNamed(RouteNames.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  spacing: 10,
                  children: [
                    Icon(
                      Icons.home,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    Center(child: H1('DreamDwell', fontSize: 48)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: const BodyText(
                  'Find Your Perfect Home.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
