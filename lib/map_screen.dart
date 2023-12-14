
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();



  Location location = new Location();

  bool ?_serviceEnabled;
  PermissionStatus ?_permissionGranted;
  LocationData ?_locationData ;

 getLocation()async{
   _serviceEnabled = await location.serviceEnabled();
   if (!_serviceEnabled!) {
     _serviceEnabled = await location.requestService();
     if (!_serviceEnabled!) {
       return;
     }
   }

   _permissionGranted = await location.hasPermission();
   if (_permissionGranted == PermissionStatus.denied) {
     _permissionGranted = await location.requestPermission();
     if (_permissionGranted != PermissionStatus.granted) {
       return;
     }
   }
   _locationData = await location.getLocation();
   setState(() {
   });
   print(_locationData);
 }


 @override
  void initState() {
    getLocation();

    super.initState();
  }
  final Set<Marker> markers =  {};
 addMarker (){
   setState(() {
     markers.add(
        Marker(markerId: const MarkerId("current-location"),
            position: LatLng(_locationData!.latitude!.toDouble(), _locationData!.longitude!.toDouble()),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: "renti app"
          )

        ),

     );
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_locationData!=null? SizedBox(

        child: GoogleMap(
          // zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target:LatLng(_locationData!.latitude!.toDouble(), _locationData!.longitude!.toDouble()),
            // 23.764211402055338, 90.42693159752628
            zoom: 11,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            addMarker();
          },
          markers: markers,
        ),
      ):const Center(child: CircularProgressIndicator(),),

    );
  }
}