import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../../../../shared/theme/index.dart';
import '../models/map_data.dart';
import '../services/map_service.dart';

/// Custom map widget for displaying Google Maps
class MapWidget extends StatefulWidget {
  final MapConfig config;
  final List<MapMarker> markers;
  final MapRoute? route;
  final Function(MapLocation)? onLocationSelected;
  final Function(MapLocation)? onLocationChanged;
  final bool showUserLocation;
  final bool showTraffic;
  final bool showBuildings;

  const MapWidget({
    super.key,
    required this.config,
    this.markers = const [],
    this.route,
    this.onLocationSelected,
    this.onLocationChanged,
    this.showUserLocation = true,
    this.showTraffic = false,
    this.showBuildings = true,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapService _mapService = MapService.instance;
  MapLocation? _currentLocation;
  bool _isLoading = false;
  String? _error;
  gmaps.GoogleMapController? _mapController;
  Set<gmaps.Marker> _googleMarkers = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  /// Initialize map with current location
  Future<void> _initializeMap() async {
    if (!_mapService.isInitialized) {
      setState(() {
        _error = 'Map service not initialized';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get current location (simulated for now)
      // In a real app, you would use location services
      if (widget.config.initialLocation != null) {
        _currentLocation = widget.config.initialLocation;
      } else {
        // Default to Dar es Salaam, Tanzania
        _currentLocation = const MapLocation(
          latitude: -6.7924,
          longitude: 39.2083,
          name: 'Dar es Salaam',
          address: 'Dar es Salaam, Tanzania',
        );
      }

      // Create Google Maps markers
      _createGoogleMarkers();

      setState(() {
        _isLoading = false;
      });

      widget.onLocationChanged?.call(_currentLocation!);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to initialize map: $e';
      });
    }
  }

  /// Create Google Maps markers from custom markers
  void _createGoogleMarkers() {
    _googleMarkers =
        widget.markers.map((marker) {
          return gmaps.Marker(
            markerId: gmaps.MarkerId(marker.id),
            position: gmaps.LatLng(
              marker.location.latitude,
              marker.location.longitude,
            ),
            infoWindow: gmaps.InfoWindow(
              title: marker.title ?? marker.location.name,
              snippet: marker.location.address,
            ),
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              marker.color == Colors.green
                  ? gmaps.BitmapDescriptor.hueGreen
                  : marker.color == Colors.blue
                  ? gmaps.BitmapDescriptor.hueBlue
                  : gmaps.BitmapDescriptor.hueRed,
            ),
          );
        }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return _buildLoadingState(isDarkMode);
    }

    if (_error != null) {
      return _buildErrorState(isDarkMode);
    }

    return _buildMapContent(isDarkMode);
  }

  /// Build loading state
  Widget _buildLoadingState(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            AppSpacing.gapVerticalSm,
            Text(
              'Loading Map...',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppColors.outlineVariant : AppColors.outline,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapVerticalSm,
            Text(
              'Map Error',
              style: AppTextStyles.headingSmall.copyWith(
                color:
                    isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapVerticalXs,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _error ?? 'Unknown error occurred',
                style: AppTextStyles.bodySmall.copyWith(
                  color:
                      isDarkMode
                          ? AppColors.onDarkSurface.withOpacity(0.7)
                          : AppColors.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.gapVerticalSm,
            ElevatedButton.icon(
              onPressed: _initializeMap,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build map content
  Widget _buildMapContent(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppColors.outlineVariant : AppColors.outline,
        ),
      ),
      child: Stack(
        children: [
          // Google Maps widget
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: gmaps.GoogleMap(
              onMapCreated: (gmaps.GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: gmaps.CameraPosition(
                target: gmaps.LatLng(
                  _currentLocation?.latitude ?? -6.7924,
                  _currentLocation?.longitude ?? 39.2083,
                ),
                zoom: widget.config.initialZoom,
              ),
              markers: _googleMarkers,
              myLocationEnabled: widget.showUserLocation,
              myLocationButtonEnabled: false,
              trafficEnabled: widget.showTraffic,
              buildingsEnabled: widget.showBuildings,
              compassEnabled: widget.config.showCompass,
              zoomControlsEnabled: widget.config.showZoomControls,
              mapType: _getGoogleMapType(),
              onTap: (gmaps.LatLng position) {
                final location = MapLocation(
                  latitude: position.latitude,
                  longitude: position.longitude,
                );
                widget.onLocationSelected?.call(location);
              },
              onCameraMove: (gmaps.CameraPosition position) {
                final location = MapLocation(
                  latitude: position.target.latitude,
                  longitude: position.target.longitude,
                );
                widget.onLocationChanged?.call(location);
              },
            ),
          ),

          // Map controls
          _buildMapControls(isDarkMode),

          // Route overlay
          if (widget.route != null) _buildRouteOverlay(isDarkMode),
        ],
      ),
    );
  }

  /// Get Google Maps map type
  gmaps.MapType _getGoogleMapType() {
    switch (widget.config.mapType) {
      case MapType.normal:
        return gmaps.MapType.normal;
      case MapType.satellite:
        return gmaps.MapType.satellite;
      case MapType.hybrid:
        return gmaps.MapType.hybrid;
      case MapType.terrain:
        return gmaps.MapType.terrain;
    }
  }

  /// Build map controls
  Widget _buildMapControls(bool isDarkMode) {
    return Positioned(
      top: 12,
      right: 12,
      child: Column(
        children: [
          // Zoom in button
          _buildControlButton(
            icon: Icons.add,
            onPressed: () async {
              if (_mapController != null) {
                await _mapController!.animateCamera(
                  gmaps.CameraUpdate.zoomIn(),
                );
              }
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 8),
          // Zoom out button
          _buildControlButton(
            icon: Icons.remove,
            onPressed: () async {
              if (_mapController != null) {
                await _mapController!.animateCamera(
                  gmaps.CameraUpdate.zoomOut(),
                );
              }
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 8),
          // My location button
          _buildControlButton(
            icon: Icons.my_location,
            onPressed: () async {
              if (_mapController != null && _currentLocation != null) {
                await _mapController!.animateCamera(
                  gmaps.CameraUpdate.newLatLng(
                    gmaps.LatLng(
                      _currentLocation!.latitude,
                      _currentLocation!.longitude,
                    ),
                  ),
                );
              }
            },
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  /// Build control button
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: isDarkMode ? AppColors.onDarkSurface : AppColors.onSurface,
        ),
      ),
    );
  }

  /// Build route overlay
  Widget _buildRouteOverlay(bool isDarkMode) {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.route, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Route Information',
                    style: AppTextStyles.bodySmall.copyWith(
                      color:
                          isDarkMode
                              ? AppColors.onDarkSurface
                              : AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.route?.distance != null)
                    Text(
                      'Distance: ${_mapService.formatDistance(widget.route!.distance!)}',
                      style: AppTextStyles.caption.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.7)
                                : AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  if (widget.route?.duration != null)
                    Text(
                      'Duration: ${_mapService.formatDuration(widget.route!.duration!)}',
                      style: AppTextStyles.caption.copyWith(
                        color:
                            isDarkMode
                                ? AppColors.onDarkSurface.withOpacity(0.7)
                                : AppColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
