import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  Location location = Location();
  Set<Marker> markers = {};
  double latitude = 0;
  double longitude = 0;

  Future<bool> isLocationServiceEnabled()async{
    bool isServiceEnabled;
    isServiceEnabled = await location.serviceEnabled();
    if(!isServiceEnabled){
      isServiceEnabled = await location.requestService();
      if(!isServiceEnabled)
        return false;

      return true;
    }else {
      return true;
    }

  }

  Future<bool> isPermissionGranted() async {
    PermissionStatus permissionGranted;
    permissionGranted = await location.hasPermission();
    if (permissionGranted != PermissionStatus.granted) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted)
        return true;
      else
        return false;
    } else {
      return true;
    }
  }



  Future<LocationData> _getUserLocation() async {
      LocationData locationData = await location.getLocation();
      return locationData;
  }

  Future<void> onMapCreated(GoogleMapController googleMapController, BuildContext context) async {
    bool serviceEnabled = await isLocationServiceEnabled();
    bool permissionGranted = await isPermissionGranted();

    if(serviceEnabled && permissionGranted){
      LocationData locationData = await _getUserLocation();
      latitude = locationData.latitude ?? 0;
      longitude = locationData.longitude ?? 0;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(locationData.latitude!, locationData.longitude!),
              zoom: 15)));
      markers.add(Marker(markerId: MarkerId('id1'),position: LatLng(locationData.latitude!, locationData.longitude!)));
    } else
      return;

  }

  void onMapTap(LatLng latLng){
    latitude = latLng.latitude;
    longitude = latLng.longitude;
    markers.clear();
    markers.add(Marker(markerId: MarkerId('id1'),position: LatLng(latLng.latitude, latLng.longitude)));
  }
}
