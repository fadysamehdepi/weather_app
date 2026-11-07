class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;
  final List<ForecastDay> forecast;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'],
      country: json['location']['country'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      feelsLike: (json['current']['feelslike_c'] as num).toDouble(),
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
      humidity: json['current']['humidity'],
      windSpeed: (json['current']['wind_kph'] as num).toDouble(),
      forecast: (json['forecast']['forecastday'] as List)
          .map((e) => ForecastDay.fromJson(e))
          .toList(),
    );
  }
}

class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemp: (json['day']['mintemp_c'] as num).toDouble(),
      condition: json['day']['condition']['text'],
      icon: json['day']['condition']['icon'],
    );
  }
}
