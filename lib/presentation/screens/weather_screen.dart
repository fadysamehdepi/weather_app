import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/weather_cubit.dart';
import '../cubit/weather_states.dart';
import '../../data/models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff172B4D),
      appBar: AppBar(
        title: const Text('SkyPulse', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff172B4D),
        actions: [
          IconButton(
            onPressed: () {
              context.read<WeatherCubit>().getWeather(
                cityController.text.isEmpty ? 'Cairo' : cityController.text,
              );
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (cityController.text.trim().isNotEmpty) {
                      context.read<WeatherCubit>().getWeather(
                        cityController.text.trim(),
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<WeatherCubit>().getWeather(value.trim());
                }
              },
            ),

            const SizedBox(height: 25),

            Expanded(
              child: BlocBuilder<WeatherCubit, WeatherStates>(
                builder: (context, state) {
                  if (state is WeatherInitial || state is WeatherLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (state is WeatherError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 60,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              context.read<WeatherCubit>().getWeather('Cairo');
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is WeatherSuccess) {
                    return WeatherContent(weather: state.weather);
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherContent extends StatelessWidget {
  final WeatherModel weather;

  const WeatherContent({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),

          Text(
            '${weather.cityName}, ${weather.country}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Image.network('https:${weather.icon}', width: 110, height: 110),

          Text(
            '${weather.temperature.round()}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 65,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            weather.condition,
            style: const TextStyle(color: Colors.white70, fontSize: 20),
          ),

          Text(
            'Feels like ${weather.feelsLike.round()}°C',
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: weatherDetail(
                  Icons.water_drop,
                  'Humidity',
                  '${weather.humidity}%',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: weatherDetail(
                  Icons.air,
                  'Wind',
                  '${weather.windSpeed} km/h',
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '3 Days Forecast',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 15),

          ...weather.forecast.map((day) => forecastItem(day)),
        ],
      ),
    );
  }

  Widget weatherDetail(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget forecastItem(ForecastDay day) {
    final date = DateTime.parse(day.date);

    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              weekdays[date.weekday - 1],
              style: const TextStyle(color: Colors.white),
            ),
          ),

          Image.network('https:${day.icon}', width: 45, height: 45),

          Expanded(
            child: Text(
              day.condition,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),

          Text(
            '${day.maxTemp.round()}° / ${day.minTemp.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
