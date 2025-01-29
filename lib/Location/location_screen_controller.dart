import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location_app/CommonWidgets/CustomToast.dart';
import 'package:location_app/CommonWidgets/strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class LocationScreenController extends GetxController  {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static StreamSubscription<Position>? positionStream;
  static var locationData = <String>[].obs;
  static Timer? locationUpdateTimer;

  @override
  void onInit() {
    super.onInit();
    loadSavedLocations();
  }
  /// Initialize Notifications
  static Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Show Notification
  static Future<void> showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'location_channel_id',
      'Location Updates',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Location Update',
      message,
      platformChannelSpecifics,
    );
  }

  /// Request Location Permission
  static Future<void> requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      customToast(Strings.locationGrant);
    } else {
      customToast(Strings.locationDeny);
    }
  }

  /// Request Notification Permission
  static Future<void> requestNotificationPermission(BuildContext context) async {
  PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      customToast(Strings.notifyGrant);
    } else if (status.isDenied) {
      customToast(Strings.notifyDeny);
    } else if(status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// Start Location Updates
   static void startLocationUpdates(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(Strings.startLocation),
        content: Text(Strings.alertMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Strings.no),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmStartLocationUpdates();
            },
            child: Text(Strings.yes),
          ),
        ],
      ),
    );
  }

  static void _confirmStartLocationUpdates() {
    showNotification(Strings.locationUpdate);

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    // Cancel previous streams if any
    positionStream?.cancel();

    // Start real-time location stream
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) async {
      await _saveLocation(position);
    });

    // Schedule periodic updates every 30 seconds
    locationUpdateTimer?.cancel();
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _saveLocation(position);
    });

    customToast(Strings.alertsStartMessage);
  }

  static Future<void> _saveLocation(Position position) async {
    String location = "Lat: ${position.latitude}, Lng: ${position.longitude}, Speed: ${position.speed} m/s";
    locationData.insert(0, location);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('locations', locationData);
  }

  /// Stop Location Updates
  static void stopLocationUpdates(BuildContext context) {
    positionStream?.cancel();
    locationUpdateTimer?.cancel();
    showNotification(Strings.alertStopMessage);
    customToast(Strings.alertsStopMessage);
  }

  /// Load Saved Locations
  Future<void> loadSavedLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList('locations');
    if (savedLocations != null) {
      locationData.assignAll(savedLocations);
    }
  }
}
