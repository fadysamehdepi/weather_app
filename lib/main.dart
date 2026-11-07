import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/data/repositories/weather_repository.dart';
import 'package:weather_app/data/services/weather_service.dart';
import 'package:weather_app/presentation/cubit/weather_cubit.dart';
import 'package:weather_app/presentation/screens/splash_screen.dart';

void main() {
  final dio = Dio();

  final weatherService = WeatherService(dio: dio);

  final weatherRepository = WeatherRepository(weatherService: weatherService);

  runApp(MyApp(repository: weatherRepository));
}

class MyApp extends StatelessWidget {
  final WeatherRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(repository)..getWeather('Cairo'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
