// features/report/report_popup.dart
import 'package:flutter/material.dart';
import 'report_controller.dart';

class ReportPopup extends StatefulWidget {
  const ReportPopup({super.key});

  @override
  State<ReportPopup> createState() => _ReportPopupState();
}

class _ReportPopupState extends State<ReportPopup> {
  String selectedType = '';
  double notificationRadius = 5.0;
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF0000), Color(0xFFFF4500)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.warning_amber_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'WHAT HAPPENED?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildEmergencyTypeButtons(),
              const SizedBox(height: 20),
              _buildDescriptionField(),
              const SizedBox(height: 20),
              _buildRadiusSelector(),
              const SizedBox(height: 20),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyTypeButtons() {
    final types = [
      {'label': 'Road accident', 'icon': Icons.directions_car},
      {'label': 'Missing child', 'icon': Icons.child_care},
      {'label': 'Fire emergency', 'icon': Icons.local_fire_department},
      {'label': 'Medical emergency', 'icon': Icons.local_hospital},
      {'label': 'Other', 'icon': Icons.add_circle_outline},
    ];

    return Column(
      children: types.map((type) {
        final isSelected = selectedType == type['label'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedType = type['label'] as String;
              });
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                  colors: [Color(0xFFFF0000), Color(0xFFFF4500)],
                )
                    : null,
                color: isSelected ? null : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    type['icon'] as IconData,
                    size: 28,
                    color: isSelected ? Colors.white : Colors.black54,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    type['label'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: descriptionController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Describe what happened (optional)',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildRadiusSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF4500).withOpacity(0.1),
            const Color(0xFFFF6347).withOpacity(0.1)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Alert Radius',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'People within ${notificationRadius.toInt()} km will be notified',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '1 km',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Expanded(
                child: Slider(
                  value: notificationRadius,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  activeColor: Colors.red,
                  inactiveColor: Colors.red.shade100,
                  onChanged: (value) {
                    setState(() {
                      notificationRadius = value;
                    });
                  },
                ),
              ),
              Text(
                '50 km',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        onPressed: () {
          if (selectedType.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select an emergency type'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Report sent! People within ${notificationRadius.toInt()}km will be notified.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'SEND REPORT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}