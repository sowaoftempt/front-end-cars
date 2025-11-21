import 'package:flutter/material.dart';


class ScrollingAdviceBanner extends StatefulWidget {
  const ScrollingAdviceBanner({super.key});

  @override
  State<ScrollingAdviceBanner> createState() => _ScrollingAdviceBannerState();
}

class _ScrollingAdviceBannerState extends State<ScrollingAdviceBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _adviceItems = [
    {
      'icon': Icons.warning_amber_rounded,
      'text': 'Stay alert to nearby emergencies',
    },
    {
      'icon': Icons.health_and_safety,
      'text': 'Keep calm and assess the situation',
    },
    {
      'icon': Icons.phone_in_talk,
      'text': 'Contact emergency services immediately',
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    if (_currentPage < _adviceItems.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ).then((_) {
      if (mounted) {
        Future.delayed(const Duration(seconds: 4), _autoScroll);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF0000), Color(0xFFDC143C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: _adviceItems.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final item = _adviceItems[index];
          return Row(
            children: [
              const SizedBox(width: 24),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'], color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item['text'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],
          );
        },
      ),
    );
  }
}
