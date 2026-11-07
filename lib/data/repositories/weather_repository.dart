import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_service.dart';

class WeatherRepository {
  final WeatherService weatherService;

  new({required this.weatherService});
  Future<WeatherModel> getWeather(String city) async {
    final data = await weatherService.getWeather(city);
    return WeatherModel.fromJson(data);
  }
}
