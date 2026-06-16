import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tickoff/l10n/app_localizations.dart';
import 'package:tickoff/src/services/guest_session.dart';
import 'package:tickoff/src/services/notification_controller.dart';
import 'package:tickoff/src/services/tick_bite_service.dart';
import 'dart:math' as math;

class _TickCluster {
  const _TickCluster({
    required this.members,
    required this.center,
  });

  final List<TickBite> members;
  final LatLng center;

  int get count => members.length;
}

class RiskMapPage extends StatefulWidget {
  const RiskMapPage({super.key});

  @override
  State<RiskMapPage> createState() => _RiskMapPageState();
}

class _RiskMapPageState extends State<RiskMapPage> {
  final MapController _mapController = MapController();
  final TickBiteService _tickBiteService = TickBiteService();
  final Distance _distance = const Distance();
  MapCamera? _currentCamera;
  LatLng? _currentLocation;
  String? _currentTickOwnerId;
  bool _isLoading = false;
  bool _isAddMode = false;
  double _currentZoom = _initialZoom;

  static const LatLng _initialCenter = LatLng(
    37.42796133580664,
    -122.085749655962,
  );
  static const double _initialZoom = 14.4746;
  static const double _circleRadiusMeters = 100.0; // Fixed radius in meters

  @override
  void initState() {
    super.initState();
    _loadCurrentTickOwnerId();
    _askPermission();
  }

  Future<void> _loadCurrentTickOwnerId() async {
    final currentOwnerId = await _tickBiteService.deviceUserId;
    if (mounted) {
      setState(() => _currentTickOwnerId = currentOwnerId);
    }
  }

  Future<void> _askPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (mounted && status.isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_currentLocation!, _initialZoom);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _addTickBiteAtLocation(LatLng location) async {
    setState(() => _isLoading = true);

    try {
      await _tickBiteService.addTickBite(location);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;

        // Show notification popup if enabled
        NotificationController.showTickBiteNotification(
          context,
          title: l10n.newTickBiteTitle,
          message: l10n.newTickBiteMessage,
        );

        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorSaving}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isAddMode = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: Text(l10n.successfullySaved),
        content: Text(l10n.tickBiteSavedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _toggleAddMode() {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isAddMode = !_isAddMode);
    if (_isAddMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.tapToMark),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _addAtCurrentLocation() async {
    final l10n = AppLocalizations.of(context)!;
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.locationLoading),
          backgroundColor: Colors.orange,
        ),
      );
      await _getCurrentLocation();
      if (_currentLocation == null) return;
    }
    _addTickBiteAtLocation(_currentLocation!);
  }

  List<_TickCluster> _buildClusters(List<TickBite> tickBites) {
    final remaining = List<TickBite>.from(tickBites);
    final clusters = <_TickCluster>[];
    final camera = _currentCamera;
    final thresholdPixels = _clusterThresholdPixels(_currentZoom);
    final fallbackThresholdMeters = _clusterFallbackThresholdMeters(_currentZoom);

    while (remaining.isNotEmpty) {
      final seed = remaining.removeAt(0);
      final clusterMembers = <TickBite>[seed];

      var index = 0;
      while (index < clusterMembers.length) {
        final current = clusterMembers[index];
        var candidateIndex = 0;

        while (candidateIndex < remaining.length) {
          final candidate = remaining[candidateIndex];
          final isNear = camera != null
              ? _projectedPixelDistance(
                    camera,
                    current.location,
                    candidate.location,
                  ) <=
                  thresholdPixels
              : _distance.as(
                    LengthUnit.Meter,
                    current.location,
                    candidate.location,
                  ) <=
                  fallbackThresholdMeters;

          if (isNear) {
            clusterMembers.add(candidate);
            remaining.removeAt(candidateIndex);
          } else {
            candidateIndex++;
          }
        }

        index++;
      }

      clusters.add(
        _TickCluster(
          members: clusterMembers,
          center: _clusterCenter(clusterMembers),
        ),
      );
    }

    return clusters;
  }

  double _clusterThresholdPixels(double zoom) {
    final normalizedZoom = zoom.clamp(5.0, 18.0);
    final zoomedOutBonus = (12.0 - normalizedZoom).clamp(0.0, 6.0) * 1.5;
    return (42.0 + zoomedOutBonus).clamp(42.0, 51.0);
  }

  double _clusterFallbackThresholdMeters(double zoom) {
    final normalizedZoom = zoom.clamp(5.0, 18.0);
    return 60 * math.pow(2, 15 - normalizedZoom).toDouble();
  }

  double _projectedPixelDistance(MapCamera camera, LatLng first, LatLng second) {
    final firstPoint = camera.project(first, _currentZoom);
    final secondPoint = camera.project(second, _currentZoom);
    final dx = firstPoint.x - secondPoint.x;
    final dy = firstPoint.y - secondPoint.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  LatLng _clusterCenter(List<TickBite> members) {
    final latitude =
        members.fold<double>(0, (sum, bite) => sum + bite.location.latitude) /
        members.length;
    final longitude =
        members.fold<double>(0, (sum, bite) => sum + bite.location.longitude) /
        members.length;
    return LatLng(latitude, longitude);
  }

  bool _isOwnCluster(_TickCluster cluster) {
    return cluster.members.every(_isOwnTickBite);
  }

  void _handleClusterTap(_TickCluster cluster) {
    if (cluster.count == 1) {
      _showTickBiteDetails(cluster.members.single);
      return;
    }

    final didFit = _mapController.fitCamera(
      CameraFit.coordinates(
        coordinates: cluster.members
            .map((tickBite) => tickBite.location)
            .toList(growable: false),
        padding: const EdgeInsets.all(72),
        maxZoom: 17.5,
      ),
    );

    if (!didFit) {
      final nextZoom = (_currentZoom + 2.5).clamp(_initialZoom, 18.0);
      _mapController.move(cluster.center, nextZoom);
      setState(() => _currentZoom = nextZoom);
    }
  }

  double _clusterMarkerSize(_TickCluster cluster) {
    return cluster.count == 1 ? 34 : (42 + (cluster.count - 2) * 6).clamp(42, 72).toDouble();
  }

  double _clusterCircleRadius(_TickCluster cluster) {
    if (cluster.count == 1) return _circleRadiusMeters;
    return (_circleRadiusMeters * (1 + math.sqrt(cluster.count - 1) * 0.22)).clamp(
      _circleRadiusMeters,
      _circleRadiusMeters * 1.8,
    );
  }

  Color _clusterFillColor(_TickCluster cluster) {
    return _isOwnCluster(cluster)
        ? const Color(0xFFD8B4FE).withValues(alpha: 0.22)
        : Colors.red.withValues(alpha: 0.18);
  }

  Color _clusterBorderColor(_TickCluster cluster) {
    return _isOwnCluster(cluster) ? const Color(0xFFA855F7) : Colors.red;
  }

  String _clusterCountLabel(int count) {
    if (count > 999) return '999+';
    if (count > 99) return '99+';
    return '$count';
  }

  double _clusterCountFontSize(double markerSize, String countLabel) {
    if (countLabel.length <= 2) return markerSize * 0.34;
    if (countLabel.length == 3) return markerSize * 0.26;
    return markerSize * 0.22;
  }

  Widget _buildClusterMarker(_TickCluster cluster) {
    final markerSize = _clusterMarkerSize(cluster);
    final borderColor = _clusterBorderColor(cluster);
    final fillColor = _clusterFillColor(cluster);
    final countLabel = _clusterCountLabel(cluster.count);

    return GestureDetector(
      onTap: () => _handleClusterTap(cluster),
      child: Container(
        width: markerSize,
        height: markerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fillColor,
          border: Border.all(color: borderColor, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: cluster.count == 1
              ? Icon(
                  Icons.bug_report,
                  color: borderColor,
                  size: markerSize * 0.5,
                )
              : Container(
                  constraints: BoxConstraints(
                    minWidth: markerSize * 0.58,
                    minHeight: markerSize * 0.58,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: markerSize * 0.1,
                    vertical: markerSize * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.72),
                    shape: countLabel.length <= 2
                        ? BoxShape.circle
                        : BoxShape.rectangle,
                    borderRadius: countLabel.length <= 2
                        ? null
                        : BorderRadius.circular(markerSize * 0.35),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    countLabel,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: _clusterCountFontSize(markerSize, countLabel),
                      height: 1,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  bool _isOwnTickBite(TickBite tickBite) {
    return _currentTickOwnerId != null && tickBite.userId == _currentTickOwnerId;
  }

  Future<void> _showTickBiteDetails(TickBite tickBite) async {
    final l10n = AppLocalizations.of(context)!;
    final isOwnTickBite = _isOwnTickBite(tickBite);
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    final shouldDelete = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(tickBite.timestamp),
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(l10n.timeAt(timeFormat.format(tickBite.timestamp))),
                const SizedBox(height: 4),
                Text(
                  l10n.coordinatesAt(
                    '${tickBite.location.latitude.toStringAsFixed(4)}, ${tickBite.location.longitude.toStringAsFixed(4)}',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isOwnTickBite ? l10n.yourReportDescription : l10n.communityReportDescription,
                  style: Theme.of(sheetContext).textTheme.bodyMedium,
                ),
                if (isOwnTickBite) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.of(sheetContext).pop(true),
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.delete),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    if (shouldDelete == true && mounted) {
      await _deleteTickBiteFromMap(tickBite);
    }
  }

  Future<void> _deleteTickBiteFromMap(TickBite tickBite) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteEntryTitle),
        content: Text(l10n.deleteOwnTickBiteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _tickBiteService.deleteTickBite(tickBite);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.entryDeleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on StateError {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteNotAllowed),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorDeleting}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.riskMap,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<TickBite>>(
            stream: _tickBiteService.getTickBitesStream(),
            builder: (context, snapshot) {
              final tickBites = snapshot.data ?? [];
              final clusters = _buildClusters(tickBites);

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLocation ?? _initialCenter,
                  initialZoom: _initialZoom,
                  onPositionChanged: (position, hasGesture) {
                    final zoom = position.zoom;
                    if (_currentCamera == null || zoom != _currentZoom) {
                      setState(() {
                        _currentCamera = position;
                        _currentZoom = zoom;
                      });
                    } else {
                      _currentCamera = position;
                    }
                  },
                  onTap: _isAddMode && !_isLoading
                      ? (tapPosition, latLng) => _addTickBiteAtLocation(latLng)
                      : null,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.tickoff',
                  ),
                  CircleLayer(
                    circles: clusters.map((cluster) {
                      return CircleMarker(
                        point: cluster.center,
                        radius: _clusterCircleRadius(cluster),
                        useRadiusInMeter: true,
                        color: _clusterFillColor(cluster),
                        borderColor: _clusterBorderColor(cluster),
                        borderStrokeWidth: 2,
                      );
                    }).toList(),
                  ),
                  MarkerLayer(
                    markers: [
                      ...clusters.map((cluster) {
                        final markerSize = _clusterMarkerSize(cluster);
                        return Marker(
                          point: cluster.center,
                          width: markerSize,
                          height: markerSize,
                          child: _buildClusterMarker(cluster),
                        );
                      }),
                      if (_currentLocation != null)
                        Marker(
                          point: _currentLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
          if (_isAddMode)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.touch_app_rounded,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.tapToMark,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: GuestSession.isGuest
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'add_mode',
                  onPressed: _isLoading ? null : _toggleAddMode,
                  backgroundColor:
                      _isAddMode ? scheme.primary : theme.cardColor,
                  foregroundColor:
                      _isAddMode ? scheme.onPrimary : scheme.onSurface,
                  child: Icon(
                    _isAddMode ? Icons.close_rounded : Icons.add_location_alt_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'add_current',
                  onPressed: _isLoading ? null : _addAtCurrentLocation,
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.my_location_rounded),
                  label: Text(l10n.reportHere),
                ),
              ],
            ),
    );
  }
}
