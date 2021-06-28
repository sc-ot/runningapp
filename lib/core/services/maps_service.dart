import 'package:geolocator/geolocator.dart';

class MapsService {
 static  Future<Position?> getLocation() async {
    try {
      Position? locationData = await Geolocator.getCurrentPosition();
      return locationData;
    } catch (e) {
      return null;
    }
  }
}
