import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../widgets/custom_button.dart';

class LocationHelper {
  static const double _earthRadiusKm = 6371.0;

  static double calculateDistanceKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    final dLat = _degToRad(endLatitude - startLatitude);
    final dLng = _degToRad(endLongitude - startLongitude);

    final a =
        pow(sin(dLat / 2), 2) +
        cos(_degToRad(startLatitude)) *
            cos(_degToRad(endLatitude)) *
            pow(sin(dLng / 2), 2);

    final c = 2 * asin(sqrt(a));

    return _earthRadiusKm * c;
  }

  static double _degToRad(double deg) => deg * pi / 180.0;

  static Future<bool> hasLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<LocationPermission> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermission.denied;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    if (permission == LocationPermission.denied) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> openAppSettings(BuildContext context) async {
    await Geolocator.openAppSettings();
  }

  static Future<void> openLocationSettings(BuildContext context) async {
    await Geolocator.openLocationSettings();
  }

  static Future<bool> showLocationPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    MingCuteIcons.mgc_location_fill,
                    size: 64,
                    color: Color(0xFFF98836),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Aplikasi membutuhkan\nakses lokasi untuk mencari\nChekpoint Rute terdekat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B2B2B),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: CustomButton(
                      text: 'Aktifkan Lokasi',
                      onPressed: () async {
                        final permission = await LocationHelper.checkPermission();

                        if (permission == LocationPermission.always ||
                            permission == LocationPermission.whileInUse) {
                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        } else {
                          await Geolocator.openAppSettings();
                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        }
                      },
                      variant: CustomButtonVariant.primary,
                      backgroundColor: const Color(
                        0xFF0D58D8,
                      ),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }
}
