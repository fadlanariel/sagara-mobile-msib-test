class Weather {
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return Weather(
      temperature: main['temp'], // Convert from Kelvin to Celsius
      description: weather['description'],
      humidity: main['humidity'],
      windSpeed: wind['speed'],
    );
  }
}

class Forecast {
  final String date;
  final Weather weather;

  Forecast({
    required this.date,
    required this.weather,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final weatherData = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return Forecast(
      date: json['dt_txt'],
      weather: Weather(
        temperature: weatherData['temp'], // Convert from Kelvin to Celsius
        description: weather['description'],
        humidity: weatherData['humidity'],
        windSpeed: wind['speed'],
      ),
    );
  }
}
