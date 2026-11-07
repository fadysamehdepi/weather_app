import 'package:dio/dio.dart';
import 'package:weather_app/core/constants/api_constants.dart';

class WeatherService {
  final Dio dio;

  new({required this.dio});

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await dio.get(
      ApiConstants.baseUrl + ApiConstants.forcastEndpoint,
      queryParameters: {
        'key': ApiConstants.apiKey,
        'q': city,
        'days': 3,
        'alerts': 'no',
        'lang': 'en',
      },
    );
    return response.data;
  }
}
