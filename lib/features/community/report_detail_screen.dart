// lib/features/community/report_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'community_model.dart';
import 'severity_tag.dart';
import 'community_service.dart';

class ReportDetailScreen extends StatefulWidget {
  final CommunityReportModel report;

  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    CommunityService.incrementViewCount(widget.report.id);
    
    if (widget.report.videoUrl != null) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.report.videoUrl!),
    );
    
    await _videoController!.initialize();
    setState(() => _isVideoInitialized = true);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMediaSection(),
                _buildContentSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFFF0000),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            // TODO: Implement share functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share feature coming soon!')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {
            // TODO: Implement bookmark functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bookmark feature coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMediaSection() {
    if (widget.report.videoUrl != null) {
      return _buildVideoPlayer();
    } else if (widget.report.imageUrl != null) {
      return _buildImageViewer();
    }
    return const SizedBox.shrink();
  }

  Widget _buildVideoPlayer() {
    if (!_isVideoInitialized || _videoController == null) {
      return Container(
        height: 300,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Container(
      height: 300,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
          _buildVideoControls(),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.fiber_manual_record, size: 12, color: Colors.white),
                  SizedBox(width: 6),
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

  Widget _buildVideoControls() {
    return IconButton(
      icon: Icon(
        _videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
        size: 64,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          if (_videoController!.value.isPlaying) {
            _videoController!.pause();
          } else {
            _videoController!.play();
          }
        });
      },
    );
  }

  Widget _buildImageViewer() {
    return Hero(
      tag: 'report_image_${widget.report.id}',
      child: CachedNetworkImage(
        imageUrl: widget.report.imageUrl!,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 300,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 300,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 64),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with tags
          Row(
            children: [
              SeverityTag(severity: widget.report.severity, fontSize: 14),
              const SizedBox(width: 8),
              if (widget.report.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: Color(0xFF10B981)),
                      SizedBox(width: 4),
                      Text(
                        'VERIFIED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            widget.report.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
              height: 1.3,
            ),
          ),

          const SizedBox(height: 16),

          // Metadata row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildMetaItem(Icons.access_time, widget.report.getTimeAgo()),
              _buildMetaItem(Icons.remove_red_eye, '${widget.report.viewCount} views'),
              _buildMetaItem(Icons.navigation, widget.report.getFormattedDistance()),
            ],
          ),

          const SizedBox(height: 24),

          // Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.description, size: 20, color: Color(0xFF6B7280)),
                    SizedBox(width: 8),
                    Text(
                      'Report Details',
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
                  widget.report.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Location section
          _buildLocationSection(),

          const SizedBox(height: 24),

          // Author section
          _buildAuthorSection(),

          const SizedBox(height: 24),

          // Action buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withOpacity(0.1),
            const Color(0xFF3B82F6).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF3B82F6), size: 24),
              SizedBox(width: 12),
              Text(
                'Location Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Area', widget.report.location),
          _buildInfoRow('Distance', widget.report.getFormattedDistance()),
          if (widget.report.latitude != null && widget.report.longitude != null)
            _buildInfoRow(
              'Coordinates',
              '${widget.report.latitude!.toStringAsFixed(4)}, ${widget.report.longitude!.toStringAsFixed(4)}',
            ),
        ],
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF0000), Color(0xFFFF4500)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.report.author,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Official Report',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to map
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening map...')),
              );
            },
            icon: const Icon(Icons.map),
            label: const Text('View on Map'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Get directions
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Getting directions...')),
              );
            },
            icon: const Icon(Icons.directions),
            label: const Text('Directions'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3B82F6),
              side: const BorderSide(color: Color(0xFF3B82F6)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
