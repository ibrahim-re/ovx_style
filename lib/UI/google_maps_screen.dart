import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/helper/auth_helper.dart';
import 'package:ovx_style/helper/location_helper.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({Key? key, required this.navigator}) : super(key: key);

  final GlobalKey<NavigatorState> navigator;

  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  LocationHelper locationHelper = LocationHelper();
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'select location'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AuthHelper.userInfo['latitude'] = locationHelper.latitude;
              AuthHelper.userInfo['longitude'] = locationHelper.longitude;
              NamedNavigatorImpl().pop();
            },
            child: Text(
              'confirm'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: MyColors.secondaryColor,
              ),
            ),
          ),
        ],
      ),
      body: GoogleMap(
        markers: locationHelper.markers,
        onMapCreated: (googleMapController) async {
          await locationHelper.onMapCreated(googleMapController, context);
          setState(() {
            markers = locationHelper.markers;
          });
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.75177, -122.41514),
          zoom: 15,
        ),
        onTap: (latLng) {
          locationHelper.onMapTap(latLng);
          setState(() {
            markers = locationHelper.markers;
          });
        },
      ),
    );
  }
}
