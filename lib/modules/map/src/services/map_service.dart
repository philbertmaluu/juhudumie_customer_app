import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/map_data.dart';

/// Google Maps service for handling map operations
class MapService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';
  static const String _geocodingUrl = '$_baseUrl/geocode/json';
  static const String _directionsUrl = '$_baseUrl/directions/json';
  static const String _placesUrl = '$_baseUrl/place';
  static const String _distanceMatrixUrl = '$_baseUrl/distancematrix/json';

  String? _apiKey;
  static MapService? _instance;

  MapService._();

  /// Get singleton instance
  static MapService get instance {
    _instance ??= MapService._();
    return _instance!;
  }

  /// Initialize the service with API key
  void initialize(String apiKey) {
    _apiKey = apiKey;
  }

  /// Check if service is initialized
  bool get isInitialized => _apiKey != null && _apiKey!.isNotEmpty;

  /// Get current API key
  String? get apiKey => _apiKey;

  /// Geocode an address to coordinates
  Future<MapServiceResult<MapLocation>> geocodeAddress(String address) async {
    if (!isInitialized) {
      return MapServiceResult.error('Map service not initialized');
    }

    try {
      final url = Uri.parse(
        '$_geocodingUrl?address=${Uri.encodeComponent(address)}&key=$_apiKey',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final geometry = result['geometry']['location'];

          final location = MapLocation(
            latitude: geometry['lat'].toDouble(),
            longitude: geometry['lng'].toDouble(),
            address: result['formatted_address'],
            name:
                result['address_components'].isNotEmpty
                    ? result['address_components'][0]['long_name']
                    : null,
          );

          return MapServiceResult.success(location);
        } else {
          return MapServiceResult.error(
            data['error_message'] ?? 'Geocoding failed',
            data['status'],
          );
        }
      } else {
        return MapServiceResult.error(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return MapServiceResult.error('Geocoding error: $e');
    }
  }

  /// Reverse geocode coordinates to address
  Future<MapServiceResult<MapLocation>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    if (!isInitialized) {
      return MapServiceResult.error('Map service not initialized');
    }

    try {
      final url = Uri.parse(
        '$_geocodingUrl?latlng=$latitude,$longitude&key=$_apiKey',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final result = data['results'][0];

          final location = MapLocation(
            latitude: latitude,
            longitude: longitude,
            address: result['formatted_address'],
            name:
                result['address_components'].isNotEmpty
                    ? result['address_components'][0]['long_name']
                    : null,
          );

          return MapServiceResult.success(location);
        } else {
          return MapServiceResult.error(
            data['error_message'] ?? 'Reverse geocoding failed',
            data['status'],
          );
        }
      } else {
        return MapServiceResult.error(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return MapServiceResult.error('Reverse geocoding error: $e');
    }
  }

  /// Get directions between two points
  Future<MapServiceResult<MapRoute>> getDirections(
    MapLocation origin,
    MapLocation destination, {
    MapRouteType mode = MapRouteType.driving,
    List<MapLocation>? waypoints,
  }) async {
    if (!isInitialized) {
      return MapServiceResult.error('Map service not initialized');
    }

    try {
      final originStr = '${origin.latitude},${origin.longitude}';
      final destinationStr = '${destination.latitude},${destination.longitude}';
      final modeStr = _getModeString(mode);

      String url =
          '$_directionsUrl?origin=$originStr&destination=$destinationStr&mode=$modeStr&key=$_apiKey';

      if (waypoints != null && waypoints.isNotEmpty) {
        final waypointStr = waypoints
            .map((w) => '${w.latitude},${w.longitude}')
            .join('|');
        url += '&waypoints=$waypointStr';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          final routeLocations = <MapLocation>[
            origin,
            if (waypoints != null) ...waypoints,
            destination,
          ];

          final mapRoute = MapRoute(
            id: route['overview_polyline']['points'],
            waypoints: routeLocations,
            distance: leg['distance']['value'].toDouble(),
            duration: leg['duration']['value'],
            polyline: route['overview_polyline']['points'],
            type: mode,
          );

          return MapServiceResult.success(mapRoute);
        } else {
          return MapServiceResult.error(
            data['error_message'] ?? 'Directions failed',
            data['status'],
          );
        }
      } else {
        return MapServiceResult.error(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return MapServiceResult.error('Directions error: $e');
    }
  }

  /// Get distance and duration between two points
  Future<MapServiceResult<Map<String, dynamic>>> getDistanceMatrix(
    List<MapLocation> origins,
    List<MapLocation> destinations, {
    MapRouteType mode = MapRouteType.driving,
  }) async {
    if (!isInitialized) {
      return MapServiceResult.error('Map service not initialized');
    }

    try {
      final originsStr = origins
          .map((o) => '${o.latitude},${o.longitude}')
          .join('|');
      final destinationsStr = destinations
          .map((d) => '${d.latitude},${d.longitude}')
          .join('|');
      final modeStr = _getModeString(mode);

      final url = Uri.parse(
        '$_distanceMatrixUrl?origins=$originsStr&destinations=$destinationsStr&mode=$modeStr&key=$_apiKey',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          return MapServiceResult.success(data);
        } else {
          return MapServiceResult.error(
            data['error_message'] ?? 'Distance matrix failed',
            data['status'],
          );
        }
      } else {
        return MapServiceResult.error(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return MapServiceResult.error('Distance matrix error: $e');
    }
  }

  /// Search for places near a location
  Future<MapServiceResult<List<MapLocation>>> searchPlaces(
    String query,
    MapLocation location, {
    double radius = 5000, // 5km default
  }) async {
    if (!isInitialized) {
      return MapServiceResult.error('Map service not initialized');
    }

    try {
      final locationStr = '${location.latitude},${location.longitude}';
      final url = Uri.parse(
        '$_placesUrl/textsearch/json?query=${Uri.encodeComponent(query)}&location=$locationStr&radius=$radius&key=$_apiKey',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final places = <MapLocation>[];

          for (final place in data['results']) {
            final geometry = place['geometry']['location'];
            places.add(
              MapLocation(
                latitude: geometry['lat'].toDouble(),
                longitude: geometry['lng'].toDouble(),
                name: place['name'],
                address: place['formatted_address'],
                description:
                    place['types'].isNotEmpty ? place['types'][0] : null,
              ),
            );
          }

          return MapServiceResult.success(places);
        } else {
          return MapServiceResult.error(
            data['error_message'] ?? 'Places search failed',
            data['status'],
          );
        }
      } else {
        return MapServiceResult.error(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return MapServiceResult.error('Places search error: $e');
    }
  }

  /// Calculate distance between two points (Haversine formula)
  double calculateDistance(MapLocation point1, MapLocation point2) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final lat1Rad = point1.latitude * (3.14159265359 / 180);
    final lat2Rad = point2.latitude * (3.14159265359 / 180);
    final deltaLatRad =
        (point2.latitude - point1.latitude) * (3.14159265359 / 180);
    final deltaLngRad =
        (point2.longitude - point1.longitude) * (3.14159265359 / 180);

    final a =
        sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLngRad / 2) *
            sin(deltaLngRad / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    }
  }

  /// Format duration for display
  String formatDuration(int durationInSeconds) {
    final hours = durationInSeconds ~/ 3600;
    final minutes = (durationInSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get mode string for API calls
  String _getModeString(MapRouteType mode) {
    switch (mode) {
      case MapRouteType.driving:
        return 'driving';
      case MapRouteType.walking:
        return 'walking';
      case MapRouteType.bicycling:
        return 'bicycling';
      case MapRouteType.transit:
        return 'transit';
    }
  }

  /// Create delivery tracking from order data
  DeliveryTracking createDeliveryTracking({
    required String orderId,
    required MapLocation pickupLocation,
    required MapLocation deliveryLocation,
    MapLocation? currentLocation,
    DeliveryStatus status = DeliveryStatus.pending,
    DateTime? estimatedDelivery,
    String? deliveryManId,
    String? deliveryManName,
    String? deliveryManPhone,
  }) {
    return DeliveryTracking(
      orderId: orderId,
      pickupLocation: pickupLocation,
      deliveryLocation: deliveryLocation,
      currentLocation: currentLocation,
      status: status,
      estimatedDelivery: estimatedDelivery,
      deliveryManId: deliveryManId,
      deliveryManName: deliveryManName,
      deliveryManPhone: deliveryManPhone,
    );
  }

  /// Update delivery tracking location
  Future<MapServiceResult<DeliveryTracking>> updateDeliveryLocation(
    DeliveryTracking tracking,
    MapLocation newLocation,
  ) async {
    try {
      // Get updated route if needed
      MapRoute? updatedRoute;
      if (tracking.currentLocation != null) {
        final routeResult = await getDirections(
          newLocation,
          tracking.deliveryLocation,
          mode: MapRouteType.driving,
        );

        if (routeResult.success && routeResult.data != null) {
          updatedRoute = routeResult.data!;
        }
      }

      final updatedTracking = tracking.copyWith(
        currentLocation: newLocation,
        route: updatedRoute?.waypoints ?? tracking.route,
      );

      return MapServiceResult.success(updatedTracking);
    } catch (e) {
      return MapServiceResult.error('Failed to update delivery location: $e');
    }
  }
}
