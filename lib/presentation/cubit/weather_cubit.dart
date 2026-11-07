import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';
import 'package:weather_app/presentation/cubit/weather_states.dart';

class WeatherCubit extends Cubit<WeatherStates> {
  final WeatherRepository repository;
  WeatherCubit(this.repository) : super(WeatherInitial());

  Future<void> getWeather(String city) async {
    emit(WeatherLoading());

    try {
      final weather = await repository.getWeather(city);
      emit(WeatherSuccess(weather: weather));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
}
