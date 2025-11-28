// lib/features/community/community_activities_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'community_model.dart';
import 'community_service.dart';
import 'severity_tag.dart';
import '../../config/app_theme.dart';
import 'report_detail_screen.dart';
import 'community_stats_widget.dart';

class CommunityActivitiesScreen extends StatefulWidget {
  const CommunityActivitiesScreen({super.key});

  @override
  State<CommunityActivitiesScreen> createState() => _CommunityActivitiesScreenState();
}

class _CommunityActivitiesScreenState extends State<CommunityActivitiesScreen> {
  double _radiusKm = 10.0;
  String? _selectedType;
  String? _selectedSeverity;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _filterTypes = [
    {'value': null, 'label': 'All', 'icon': Icons.grid_view},
    {'value': 'crime', 'label': 'Crime', 'icon': Icons.local_police},
    {'value': 'emergency', 'label': 'Emergency', 'icon': Icons.emergency},
    {'value': 'announcement', 'label': 'News', 'icon': Icons.campaign},
    {'value': 'event', 'label': 'Events', 'icon': Icons.event},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildRadiusSelector(),
                _buildFilterChips(),
                CommunityStatsWidget(radiusKm: _radiusKm),
              ],
            ),
          ),
          _buildReportsList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFFF0000),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'My Community',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF0000),
                const Color(0xFFFF0000).withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: 20,
                child: Icon(
                  Icons.location_city,
                  size: 120,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {});
          },
          tooltip: 'Refresh',
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterBottomSheet,
          tooltip: 'Filters',
        ),
      ],
    );
  }

  Widget _buildRadiusSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF4500).withOpacity(0.1),
            const Color(0xFFFF6347).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF4500).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFFFF0000),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Community Radius',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Showing incidents within ${_radiusKm.toInt()} km',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                '1 km',
                style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
              Expanded(
                child: Slider(
                  value: _radiusKm,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  activeColor: const Color(0xFFFF0000),
                  inactiveColor: const Color(0xFFFF0000).withOpacity(0.2),
                  onChanged: (value) {
                    setState(() => _radiusKm = value);
                  },
                ),
              ),
              const Text(
                '50 km',
                style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filterTypes.length,
        itemBuilder: (context, index) {
          final filter = _filterTypes[index];
          final isSelected = _selectedType == filter['value'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 6),
                  Text(filter['label'] as String),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedType = selected ? filter['value'] as String? : null;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFFFF0000),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFFFF0000)
                    : const Color(0xFFE5E7EB),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportsList() {
    return StreamBuilder<List<CommunityReportModel>>(
      stream: CommunityService.getCommunityReportsStream(radiusKm: _radiusKm),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Container(
              height: 400,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Color(0xFFFF0000),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: _buildErrorState(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildEmptyState(),
          );
        }

        var reports = snapshot.data!;

        // Apply filters
        if (_selectedType != null) {
          reports =
              reports.where((r) => r.reportType == _selectedType).toList();
        }
        if (_selectedSeverity != null) {
          reports =
              reports.where((r) => r.severity == _selectedSeverity).toList();
        }

        if (reports.isEmpty) {
          return SliverToBoxAdapter(child: _buildEmptyState());
        }

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildReportCard(reports[index]),
              childCount: reports.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportCard(CommunityReportModel report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showReportDetails(report),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media Section
              if (report.imageUrl != null || report.videoUrl != null)
                _buildMediaSection(report),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with severity tag
                    Row(
                      children: [
                        SeverityTag(severity: report.severity),
                        const SizedBox(width: 8),
                        if (report.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: Color(0xFF10B981),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'VERIFIED',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        Text(
                          report.getTimeAgo(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      report.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Footer Info
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.location_on,
                          report.getFormattedDistance(),
                          const Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.location_city,
                          report.location,
                          const Color(0xFF8B5CF6),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.remove_red_eye,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          report.viewCount.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
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

  Widget _buildMediaSection(CommunityReportModel report) {
    if (report.videoUrl != null) {
      return _buildVideoThumbnail(report);
    } else if (report.imageUrl != null) {
      return _buildImageSection(report);
    }
    return const SizedBox.shrink();
  }

  Widget _buildImageSection(CommunityReportModel report) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: report.imageUrl!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            errorWidget: (context, url, error) =>
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 64),
                ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.photo_camera, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Photo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail(CommunityReportModel report) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[900],
            child: const Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.videocam, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 400,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No reports nearby',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try increasing your community radius',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Severity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: ['low', 'medium', 'high', 'critical'].map((
                      severity) {
                    final isSelected = _selectedSeverity == severity;
                    return FilterChip(
                      label: Text(severity.toUpperCase()),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSeverity = selected ? severity : null;
                        });
                        Navigator.pop(context);
                      },
                      selectedColor: const Color(0xFFFF0000).withOpacity(0.2),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
    );
  }

  void _showReportDetails(CommunityReportModel report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetailScreen(report: report),
      ),
    );
  }

  // Keep the old bottom sheet method as backup
  void _showReportDetailsBottomSheet(CommunityReportModel report) {
    Widget _buildDetailRow(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF6B7280)),
            const SizedBox(width: 12),
            Text(
              '$label: ',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}


