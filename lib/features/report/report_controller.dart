import 'package:flutter/material.dart';
import 'report_model.dart';
import 'report_service.dart';
import '../../widgets/emergency_button_grid.dart';
import '../../services/location_service.dart';

class ReportController {
  String selectedType = '';
  final TextEditingController descriptionController = TextEditingController();

  Widget buildReportPopup(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WHAT HAPPENED?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 20),
            EmergencyTypeSelector(
              selectedType: selectedType,
              onTypeSelected: (type) {
                selectedType = type;
              },
            ),
            const SizedBox(height: 20),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildPhotoButton(context),
            const SizedBox(height: 16),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Can you explain (optional)',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildPhotoButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        icon: const Icon(Icons.camera_alt),
        label: const Text(
          'Take a photo/video',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          // TODO: Implement camera/gallery picker
          _handlePhotoSelection(context);
        },
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        onPressed: () => _handleSubmit(context),
        child: const Text(
          'SEND REPORT',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Future<void> _handlePhotoSelection(BuildContext context) async {
    // TODO: Implement image picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (selectedType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an emergency type'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Get user location for required lat/lng fields
    final userLocation = await LocationService.getCurrentLocationMap();
    final double lat = (userLocation['lat'] as double?) ?? 0.0;
    final double lng = (userLocation['lng'] as double?) ?? 0.0;

    final report = ReportModel(
      type: selectedType,
      description: descriptionController.text,
      photoUrl: null, // TODO: Add photo URL after implementing camera
      lat: lat,
      lng: lng,
    );

    try {
      await ReportService.submit(report);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('\u2705 Report submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('\u274c Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void dispose() {
    descriptionController.dispose();
  }
}