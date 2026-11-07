import 'package:weather_app/data/models/weather_model.dart';

abstract class WeatherStates {}

class WeatherInitial extends WeatherStates {}

class WeatherLoading extends WeatherStates {}

class WeatherSuccess extends WeatherStates {
  final WeatherModel weather;
  new({required this.weather});
}

class WeatherError extends WeatherStates {
  final String message;

  new({required this.message});
}
