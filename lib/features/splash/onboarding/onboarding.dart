import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';
import 'package:dreamdwell/core/theme/app_colors.dart';
import 'package:dreamdwell/features/splash/onboarding/onboarding_screen.dart';
import 'package:dreamdwell/core/routes/route_names.dart';
import 'package:dreamdwell/core/utils/constant.dart';
import 'package:dreamdwell/core/shared/widgets/buttons/animated_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _MyOnboardingScreenState();
}

class _MyOnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  late bool _isLastPage;
  late bool _isFirstPage;
  int _currentIndex = 0;
  final double horizontalPadding = 20;
  final double topPadding = 80;
  final double bottomPadding = 40;
  final double buttonMinHeight = 45;
  final double buttonHorizontalPadding = 32;
  final buttonTextStyle = const TextStyle(fontSize: 18);
  final String startButtonText = "Get Started";
  final String backButtonText = "Back";
  final String nextButtonText = "Next";

  final pages = [
    const OnboardingPage(
      image:
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800&h=600&fit=crop',
      title: 'Discover Amazing Properties',
      subtitle:
          'Explore thousands of verified homes, apartments, and luxury properties with powerful search and filter options.',
    ),
    const OnboardingPage(
      image:
          'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=800&h=600&fit=crop',
      title: 'Save Your Favorites',
      subtitle:
          'Build your personal wishlist of dream properties and never miss out on price updates or new listings.',
    ),
    const OnboardingPage(
      image:
          'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=800&h=600&fit=crop',
      title: 'Your Dream Home Awaits',
      subtitle:
          'Connect directly with property owners and trusted agents to schedule viewings and secure your perfect home.',
    ),
  ];

  @override
  void initState() {
    _isLastPage = false;
    _isFirstPage = true;
    _currentIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBack() => _controller.previousPage(
    duration: const Duration(microseconds: 350),
    curve: Curves.easeInOut,
  );

  void _onNext() => _controller.nextPage(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeIn,
  );

  void _handleLastPage() {
    Navigator.of(context).pushReplacementNamed(RouteNames.main);
  }

  Widget _getPageButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: bottomPadding,
      ),
      child: Row(
        children: [
          if (!_isFirstPage)
            Expanded(
              child: AnimatedButton(
                onTap: _onBack,
                child: Container(
                  height: buttonMinHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.primary),
                  ),
                  child: Center(
                    child: BodyText(
                      backButtonText,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          if (!_isFirstPage) horizontalSpace(16),
          Expanded(
            child: AnimatedButton(
              onTap: _isLastPage ? _handleLastPage : _onNext,
              child: Container(
                height: buttonMinHeight,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: BodyText(
                    _isLastPage ? startButtonText : nextButtonText,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _isLastPage = index == pages.length - 1;
                _isFirstPage = index == 0;
              });
            },
            controller: _controller,
            children: pages,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: isLandscape ? 40 : topPadding),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 80,
                      height: 5,
                      decoration: BoxDecoration(
                        color:
                            _currentIndex == index
                                ? AppColor.primary
                                : AppColor.lightText.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _getPageButtons(context),
          ),
        ],
      ),
    );
  }
}
