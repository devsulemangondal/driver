import 'dart:developer' as developer;

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // ✅ Check if location service is enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Try to request enabling location services using 'location' plugin
        final loc.Location location = loc.Location();
        bool serviceRequestedResult = await location.requestService();
        if (!serviceRequestedResult) {
          developer.log("Location services are disabled.");
          return null;
        }
      }

      // ✅ Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          developer.log("Location permission denied by user.");
          return null;
        }
      }

      // 🚫 Handle permanently denied permission
      if (permission == LocationPermission.deniedForever) {
        developer.log("Location permissions are permanently denied. Opening app settings...");
        await openAppSettings();
        return null;
      }

      // ✅ Request higher accuracy if possible
      await Geolocator.requestPermission();

      // ✅ Get current position with best accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      developer.log("Current Location: Lat=${position.latitude}, Lng=${position.longitude}");
      return position;
    } catch (e, stack) {
      developer.log("Error getting current location", error: e, stackTrace: stack);
      return null;
    }
  }
}
