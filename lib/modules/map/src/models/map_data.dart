import 'package:flutter/material.dart';

/// Map location data model
class MapLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? name;
  final String? description;

  const MapLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
    this.description,
  });

  MapLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? name,
    String? description,
  }) {
    return MapLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'MapLocation(lat: $latitude, lng: $longitude, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapLocation &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

/// Map marker data model
class MapMarker {
  final String id;
  final MapLocation location;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final bool isDraggable;
  final Map<String, dynamic>? metadata;

  const MapMarker({
    required this.id,
    required this.location,
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.isDraggable = false,
    this.metadata,
  });

  MapMarker copyWith({
    String? id,
    MapLocation? location,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? color,
    bool? isDraggable,
    Map<String, dynamic>? metadata,
  }) {
    return MapMarker(
      id: id ?? this.id,
      location: location ?? this.location,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDraggable: isDraggable ?? this.isDraggable,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Map route data model
class MapRoute {
  final String id;
  final List<MapLocation> waypoints;
  final double? distance; // in meters
  final int? duration; // in seconds
  final String? polyline;
  final MapRouteType type;

  const MapRoute({
    required this.id,
    required this.waypoints,
    this.distance,
    this.duration,
    this.polyline,
    this.type = MapRouteType.driving,
  });

  MapRoute copyWith({
    String? id,
    List<MapLocation>? waypoints,
    double? distance,
    int? duration,
    String? polyline,
    MapRouteType? type,
  }) {
    return MapRoute(
      id: id ?? this.id,
      waypoints: waypoints ?? this.waypoints,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      polyline: polyline ?? this.polyline,
      type: type ?? this.type,
    );
  }
}

/// Map route types
enum MapRouteType { driving, walking, bicycling, transit }

/// Map configuration
class MapConfig {
  final double initialZoom;
  final MapLocation? initialLocation;
  final bool showUserLocation;
  final bool showTraffic;
  final bool showBuildings;
  final bool showCompass;
  final bool showZoomControls;
  final MapType mapType;
  final Color? primaryColor;
  final Color? secondaryColor;

  const MapConfig({
    this.initialZoom = 15.0,
    this.initialLocation,
    this.showUserLocation = true,
    this.showTraffic = false,
    this.showBuildings = true,
    this.showCompass = true,
    this.showZoomControls = true,
    this.mapType = MapType.normal,
    this.primaryColor,
    this.secondaryColor,
  });

  MapConfig copyWith({
    double? initialZoom,
    MapLocation? initialLocation,
    bool? showUserLocation,
    bool? showTraffic,
    bool? showBuildings,
    bool? showCompass,
    bool? showZoomControls,
    MapType? mapType,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return MapConfig(
      initialZoom: initialZoom ?? this.initialZoom,
      initialLocation: initialLocation ?? this.initialLocation,
      showUserLocation: showUserLocation ?? this.showUserLocation,
      showTraffic: showTraffic ?? this.showTraffic,
      showBuildings: showBuildings ?? this.showBuildings,
      showCompass: showCompass ?? this.showCompass,
      showZoomControls: showZoomControls ?? this.showZoomControls,
      mapType: mapType ?? this.mapType,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }
}

/// Map types
enum MapType { normal, satellite, hybrid, terrain }

/// Delivery tracking data
class DeliveryTracking {
  final String orderId;
  final MapLocation pickupLocation;
  final MapLocation deliveryLocation;
  final MapLocation? currentLocation;
  final List<MapLocation> route;
  final DeliveryStatus status;
  final DateTime? estimatedDelivery;
  final String? deliveryManId;
  final String? deliveryManName;
  final String? deliveryManPhone;

  const DeliveryTracking({
    required this.orderId,
    required this.pickupLocation,
    required this.deliveryLocation,
    this.currentLocation,
    this.route = const [],
    this.status = DeliveryStatus.pending,
    this.estimatedDelivery,
    this.deliveryManId,
    this.deliveryManName,
    this.deliveryManPhone,
  });

  DeliveryTracking copyWith({
    String? orderId,
    MapLocation? pickupLocation,
    MapLocation? deliveryLocation,
    MapLocation? currentLocation,
    List<MapLocation>? route,
    DeliveryStatus? status,
    DateTime? estimatedDelivery,
    String? deliveryManId,
    String? deliveryManName,
    String? deliveryManPhone,
  }) {
    return DeliveryTracking(
      orderId: orderId ?? this.orderId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      currentLocation: currentLocation ?? this.currentLocation,
      route: route ?? this.route,
      status: status ?? this.status,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      deliveryManId: deliveryManId ?? this.deliveryManId,
      deliveryManName: deliveryManName ?? this.deliveryManName,
      deliveryManPhone: deliveryManPhone ?? this.deliveryManPhone,
    );
  }
}

/// Delivery status
enum DeliveryStatus {
  pending,
  confirmed,
  preparing,
  ready,
  pickedUp,
  inTransit,
  delivered,
  failed,
  cancelled,
}

/// Map service result
class MapServiceResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? errorCode;

  const MapServiceResult({
    required this.success,
    this.data,
    this.error,
    this.errorCode,
  });

  factory MapServiceResult.success(T data) {
    return MapServiceResult(success: true, data: data);
  }

  factory MapServiceResult.error(String error, [String? errorCode]) {
    return MapServiceResult(success: false, error: error, errorCode: errorCode);
  }
}
