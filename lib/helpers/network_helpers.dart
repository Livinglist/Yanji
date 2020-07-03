//library network_helpers;
//
////import 'package:location_permissions/location_permissions.dart';
//import 'package:location/location.dart';
//import 'package:weather/weather.dart';
//import 'package:connectivity/connectivity.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:geocoder/geocoder.dart';
//import 'package:permission_handler/permission_handler.dart';
//
//export 'package:geolocator/geolocator.dart' show Position;
//
//Future checkGeoPermission() async {
//  PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse);
//  if (permission != PermissionStatus.granted) {
//    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
//    return permissions;
//  }
//  return permission;
//}
//
//Future<String> getCurrentWeatherCode() async {
//  Connectivity connectivity = Connectivity();
//  var res = await connectivity.checkConnectivity();
//  if (res != ConnectivityResult.none && false) {
//    WeatherStation weatherStation = new WeatherStation("b8544a9ddccfa0ad2ab22158291ed83a");
//    Weather weather = await weatherStation.currentWeather();
//
//    return weather.weatherIcon;
//  } else {
//    return '01d';
//  }
//}
//
//Future<Position> getCurrentPosition() async => await Geolocator().getCurrentPosition();
//
//Future<String> getCurrentAddress(double longitude, double latitude) async {
////var pos = await Geolocator().getCurrentPosition();
//
//  final coordinates = Coordinates(latitude, longitude);
//  var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//  var first = addresses.first;
//
//  String location = "${first.locality}, ${first.adminArea}, ${first.countryCode}";
//
//  return location;
//}
