import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Mock waste pickup model
class MockWastePickup {
  final String id;
  final String wasteType;
  final String scheduledDate;
  final String address;
  final String phone;
  final String description;
  final String latitude;
  final String longitude;
  final String? imageUrl;
  final DateTime timestamp;

  MockWastePickup({
    required this.id,
    required this.wasteType,
    required this.scheduledDate,
    required this.address,
    required this.phone,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.timestamp,
  });
}

/// Mock waste pickup service for unsupported platforms (Linux, Windows desktop)
class MockWastePickupService {
  MockWastePickupService();

  // In-memory storage for mock pickups
  static final List<MockWastePickup> _scheduledPickups = [];

  // Mock schedule pickup
  Future<void> schedulePickup({
    required String wasteType,
    required String scheduledDate,
    required String address,
    required String phone,
    required String description,
    required String latitude,
    required String longitude,
    String? imageUrl,
  }) async {
    if (kDebugMode) {
      print('MockWastePickupService: schedulePickup called (simulated)');
      print('Waste Type: $wasteType');
      print('Scheduled Date: $scheduledDate');
      print('Address: $address');
      print('Phone: $phone');
      print('Description: $description');
      print('Location: $latitude, $longitude');
      if (imageUrl != null) print('Image URL: $imageUrl');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Store the pickup in memory
    final pickup = MockWastePickup(
      id: 'pickup_${DateTime.now().millisecondsSinceEpoch}',
      wasteType: wasteType,
      scheduledDate: scheduledDate,
      address: address,
      phone: phone,
      description: description,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );

    _scheduledPickups.add(pickup);

    // Simulate success
    if (kDebugMode) {
      print(
          'MockWastePickupService: Pickup scheduled successfully! (Stored in memory)');
      print('Total pickups stored: ${_scheduledPickups.length}');
    }
  }

  // Mock update pickup
  Future<void> updatePickup({
    required String documentId,
    required String wasteType,
    required String scheduledDate,
    required String address,
    required String phone,
    required String description,
    required String latitude,
    required String longitude,
    String? imageUrl,
  }) async {
    if (kDebugMode) {
      print('MockWastePickupService: updatePickup called (simulated)');
      print('Document ID: $documentId');
      print('Waste Type: $wasteType');
      print('Scheduled Date: $scheduledDate');
      print('Address: $address');
      print('Phone: $phone');
      print('Description: $description');
      print('Location: $latitude, $longitude');
      if (imageUrl != null) print('Image URL: $imageUrl');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate success
    if (kDebugMode) {
      print('MockWastePickupService: Pickup updated successfully!');
    }
  }

  // Mock get current location
  Future<Position> getCurrentLocation() async {
    if (kDebugMode) {
      print('MockWastePickupService: getCurrentLocation called (simulated)');
    }

    // Return mock coordinates (San Francisco area)
    return Position(
      latitude: 37.7749,
      longitude: -122.4194,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  // Get all scheduled pickups
  Future<List<MockWastePickup>> getScheduledPickups() async {
    if (kDebugMode) {
      print(
          'MockWastePickupService: getScheduledPickups called (returning ${_scheduledPickups.length} pickups)');
    }

    // Sort by timestamp (most recent first)
    final sortedPickups = List<MockWastePickup>.from(_scheduledPickups);
    sortedPickups.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return sortedPickups;
  }

  // Get pickup by ID
  Future<MockWastePickup?> getPickupById(String id) async {
    if (kDebugMode) {
      print('MockWastePickupService: getPickupById called for ID: $id');
    }

    try {
      return _scheduledPickups.firstWhere((pickup) => pickup.id == id);
    } catch (e) {
      return null;
    }
  }

  // Delete pickup by ID
  Future<void> deletePickup(String id) async {
    if (kDebugMode) {
      print('MockWastePickupService: deletePickup called for ID: $id');
    }

    _scheduledPickups.removeWhere((pickup) => pickup.id == id);

    if (kDebugMode) {
      print(
          'MockWastePickupService: Pickup deleted. Remaining pickups: ${_scheduledPickups.length}');
    }
  }

  // Get pickup count
  int get pickupCount => _scheduledPickups.length;
}
