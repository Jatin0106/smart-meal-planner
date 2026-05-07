import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import '../../core/theme/app_colors.dart';
import '../../main.dart';
import '../../core/widgets/animated_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Track Macros",
      "subtitle": "Easily track your proteins, carbs, and fats every single day.",
      "icon": "1", // using integer to map to icon later
    },
    {
      "title": "Set Goals",
      "subtitle": "Customize your nutritional goals and let our AI insights guide you.",
      "icon": "2",
    },
    {
      "title": "Stay Offline",
      "subtitle": "No internet? No problem! Log your meals completely offline.",
      "icon": "3",
    },
  ];

  IconData _getIcon(String id) {
    switch (id) {
      case "1":
        return Icons.pie_chart;
      case "2":
        return Icons.flag;
      case "3":
        return Icons.wifi_off;
      default:
        return Icons.star;
    }
  }

  void _completeOnboarding() {
    Hive.box('settings').put('isFirstTime', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIcon(_onboardingData[index]["icon"]!),
                              size: 100,
                              color: Colors.white,
                            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                          ),
                          const SizedBox(height: 64),
                          Text(
                            _onboardingData[index]["title"]!,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn().slideY(begin: 0.3),
                          const SizedBox(height: 16),
                          Text(
                            _onboardingData[index]["subtitle"]!,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(delay: 200.ms),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_currentPage == _onboardingData.length - 1)
                      AnimatedButton(
                        text: 'Get Started',
                        onPressed: _completeOnboarding,
                        isPrimary: false,
                      ).animate().fadeIn().scale()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _completeOnboarding,
                            child: const Text('Skip', style: TextStyle(color: Colors.white70, fontSize: 16)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                            ),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
