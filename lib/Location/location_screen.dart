import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_app/CommonWidgets/strings.dart';
import 'package:location_app/CommonWidgets/width_height.dart';
import 'package:location_app/Location/location_screen_controller.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<String> locationData = [];

  @override
  void initState() {
    super.initState();
    LocationScreenController.initNotifications();
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(top: screenWidth * WidthHeight.padding,bottom: screenWidth * WidthHeight.padding),
              child: Text(
                Strings.test,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),textAlign: TextAlign.left,

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * WidthHeight.padding),
              child: isPortrait ? _buildButtonsColumn(screenSize) : _buildButtonsRow(screenSize),
            ),
             Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: locationData.length,
                    itemBuilder: (context, index) {
                      return _buildRequestItem(locationData[index],screenSize,index+1);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds Buttons in Column (Portrait Mode)
  Widget _buildButtonsColumn(Size screenSize) {
    return Column(
      children: [
        _buildButton(Colors.blue, "Request Location Permission", () => LocationScreenController.requestLocationPermission(context),screenSize,Colors.white),
        _buildButton(Colors.amber, "Request Notification Permission", () => LocationScreenController.requestNotificationPermission(context),screenSize,Colors.black),
        _buildButton(Colors.green, "Start Location Update", () => LocationScreenController.startLocationUpdates(context),screenSize,Colors.white),
        _buildButton(Colors.red, "Stop Location Update", () => LocationScreenController.stopLocationUpdates(context),screenSize,Colors.white),
      ],
    );
  }

  /// Builds Buttons in Row (Landscape Mode)
  Widget _buildButtonsRow(Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(Colors.blue,Strings.requestLocations, () => LocationScreenController.requestLocationPermission(context),screenSize,Colors.white),
        _buildButton(Colors.amber, Strings.notification, () => LocationScreenController.requestNotificationPermission(context),screenSize,Colors.black),
        _buildButton(Colors.green, Strings.startUpdate, () => LocationScreenController.startLocationUpdates(context),screenSize,Colors.white),
        _buildButton(Colors.red, Strings.stopUpdate, () => LocationScreenController.stopLocationUpdates(context),screenSize,Colors.white),
      ],
    );
  }

  /// Custom Button Widget
  Widget _buildButton(Color color, String text, VoidCallback onPressed, Size screenSize, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:  screenSize.height * 0.01),
      child: SizedBox(
        width:  screenSize.width * 0.8,
        height:  screenSize.height * 0.06,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical:  screenSize.height * 0.015),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize:  screenSize.width * 0.04, // Adaptive text size
            ),
          ),
        ),
      ),
    );
  }

  /// Custom Location list Widget
  Widget _buildRequestItem(String location, Size  screenSize,int index) {
    return Card(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(
        vertical:  screenSize.height * 0.007,
        horizontal:  screenSize.width * WidthHeight.padding,
      ),
      child: Padding(
        padding: EdgeInsets.all( screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Request$index", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              location,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:  screenSize.width * 0.045,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
