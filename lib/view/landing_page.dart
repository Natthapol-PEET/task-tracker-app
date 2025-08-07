import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:task_tracker_app/view/add_task_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Taskcy',
      subtitle: 'Building Better Workplaces',
      description:
          'Create a unique emotional story that\ndescribes better than words',
      imagePath: 'assets/images/banner-1.png',
    ),
    OnboardingSlide(
      title: 'Track Progress',
      subtitle: 'Stay Organized & Productive',
      description:
          'Monitor your tasks and projects\nwith beautiful visual progress',
      imagePath: 'assets/images/banner-2.png',
    ),
    OnboardingSlide(
      title: 'Team Collaboration',
      subtitle: 'Work Together Seamlessly',
      description: 'Connect with your team and\nachieve goals together',
      imagePath: 'assets/images/banner-3.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    // Reset and restart animation
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6B46C1), Color(0xFF8B5CF6)],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                // Top section with page view - full screen
                SizedBox(
                  width: width,
                  height: height * 0.6,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: width,
                        height: double.infinity,
                        child: Image.asset(
                          _slides[index].imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      );
                    },
                  ),
                ),
                // Bottom section with content card - full width
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: width,
                    height: height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Dots indicator
                        DotsIndicator(
                          dotsCount: _slides.length,
                          position: _currentPage.toDouble(),
                          decorator: DotsDecorator(
                            activeColor: const Color(0xFF6B46C1),
                            color: Colors.grey.shade300,
                            activeSize: const Size(30, 4),
                            size: const Size(30, 4),
                            activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Main content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                // Text content with animation
                                AnimatedBuilder(
                                  animation: _slideController,
                                  builder: (context, child) {
                                    return SlideTransition(
                                      position: _slideAnimation,
                                      child: Column(
                                        children: [
                                          // Title
                                          Text(
                                            _slides[_currentPage].title,
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6B46C1),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _slides[_currentPage].subtitle,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          // Description
                                          Text(
                                            _slides[_currentPage].description,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF6B7280),
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const Spacer(),
                                // Action buttons (no animation)
                                Row(
                                  children: [
                                    if (_currentPage > 0) ...[
                                      Expanded(
                                        child: Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFF6B46C1),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              onTap: () {
                                                _pageController.previousPage(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              },
                                              child: const Center(
                                                child: Text(
                                                  'Previous',
                                                  style: TextStyle(
                                                    color: Color(0xFF6B46C1),
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                    Expanded(
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF8B5CF6),
                                              Color(0xFF6B46C1)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF6B46C1)
                                                  .withOpacity(0.3),
                                              blurRadius: 15,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            onTap: () {
                                              if (_currentPage <
                                                  _slides.length - 1) {
                                                _pageController.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              } else {
                                                // Navigate to next page
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) =>
                                                        const AddTaskPage(),
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                    transitionsBuilder: (_,
                                                        Animation<double>
                                                            animation,
                                                        __,
                                                        Widget child) {
                                                      return SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                              0, 1),
                                                          end: Offset.zero,
                                                        ).animate(animation),
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                _currentPage <
                                                        _slides.length - 1
                                                    ? 'Next'
                                                    : 'Get Started',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Data class for onboarding slides
class OnboardingSlide {
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;

  OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
  });
}
