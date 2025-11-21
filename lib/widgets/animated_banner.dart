import 'package:flutter/material.dart';
import '../features/home/home_controller.dart';
import '../features/report/report_button.dart';
class AnimatedBanner extends StatefulWidget {
  const AnimatedBanner({super.key});

  @override
  State<AnimatedBanner> createState() => _AnimatedBannerState();
}

class _AnimatedBannerState extends State<AnimatedBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;

  final List<String> _messages = [
    'CREATE A PEACEFUL COMMUNITY',
    'REPORT EMERGENCIES QUICKLY',
    'STAY SAFE TOGETHER',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    Future.delayed(const Duration(seconds: 3), _cycleMessages);
  }

  void _cycleMessages() {
    if (!mounted) return;
    _controller.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _messages.length;
      });
      _controller.reverse().then((_) {
        if (!mounted) return;
        Future.delayed(const Duration(seconds: 3), _cycleMessages);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF4500), Color(0xFFFF6347)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 40,
                  color: Color(0xFFFF4500),
                ),
              ),
            ),
          ),
          Positioned(
            left: 100,
            right: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  _messages[_currentIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
