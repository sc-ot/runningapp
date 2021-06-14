import 'package:bestpractice/core/utils/constants.dart';
import 'package:weather/weather.dart';

class WeatherService {
  
 static Future<Weather?> getWeather(double lat, double lon) async {
   try{
      WeatherFactory wf = new WeatherFactory(Constants.API_KEY_WEATHER);
    return await wf.currentWeatherByLocation(lat, lon);
   }catch(e){

   }
   return null;
  }
}
