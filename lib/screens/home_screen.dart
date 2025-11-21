import 'package:flutter/material.dart';
import '../features/home/home_controller.dart';
import '../features/report/report_button.dart';
import '../widgets/quick_action_buttons.dart';
import '../widgets/animated_banner.dart';
import '../widgets/emergency_button_grid.dart';
import '../widgets/scrolling_advice_banner.dart';
import '../features/report/report_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const AnimatedBanner(),
              const SizedBox(height: 24),
              const EmergencyButtonsGrid(),
              const SizedBox(height: 24),
              const ScrollingAdviceBanner(),
              const SizedBox(height: 8),
              _buildPageIndicators(),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'QUICK ACTIONS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const QuickActionButtons(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildPageIndicators() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          4,
              (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == 0 ? const Color(0xFFFF0000) : Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, size: 28),
                color: _selectedIndex == 0 ? Colors.red : Colors.grey,
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 32),
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ReportPopup(),
                    );
                  },
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    color: _selectedIndex == 2 ? Colors.red : Colors.grey,
                    onPressed: () => setState(() => _selectedIndex = 2),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}