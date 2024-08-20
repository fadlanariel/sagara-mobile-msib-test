import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather_forecast/models/weather.dart';

class WeatherService with ChangeNotifier {
  final String apiKey = 'API_KEY';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<List<Forecast>> fetchThreeDayForecast(String city) async {
    final url = '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Forecast> forecasts = [];
      final Set<String> uniqueDates = {};
      final now = DateTime.now();

      // Filter forecast data to get only entries at 12:00:00
      for (var item in data['list']) {
        final dateTime = DateTime.parse(item['dt_txt']);
        final dateStr = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

        if (dateTime.hour == 12 && !uniqueDates.contains(dateStr)) {
          uniqueDates.add(dateStr);
          final forecast = Forecast.fromJson(item);
          forecasts.add(forecast);
        }

        if (uniqueDates.length > 3) break;
      }

      // Ensure we have at least 3 entries, fill with null or error if not enough data
      if (forecasts.length < 3) {
        throw Exception('Not enough forecast data available.');
      }

      return forecasts;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
