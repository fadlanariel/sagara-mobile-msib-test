import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/services/weather_service.dart';
import 'package:weather_forecast/models/weather.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString).toLocal();
    final formatter = DateFormat('EEEE, d MMMM yyyy'); // Format: Dayname, date Month year
    return formatter.format(date);
  }

  Widget _buildCurrentWeather(BuildContext context, Forecast forecast) {
    final formattedDate = _formatDate(forecast.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 5,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: Icon(Icons.cloud, size: 50), // Placeholder icon
          title: Text(
            '${forecast.weather.temperature.toStringAsFixed(1)}°C',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          subtitle: Text(
            '${forecast.weather.description}\nHumidity: ${forecast.weather.humidity}%\nWind Speed: ${forecast.weather.windSpeed} m/s',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              // Add functionality for location or settings
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Forecast>>(
        future: Provider.of<WeatherService>(context).fetchThreeDayForecast('Jakarta'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final forecasts = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Current Weather',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _buildCurrentWeather(context, forecasts.first), // Display current weather

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '3-Day Forecast',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: forecasts.length - 1, // Remove first item
                    itemBuilder: (context, index) {
                      final forecast = forecasts[index + 1]; // Skip the first item
                      return ListTile(
                        leading: Icon(Icons.calendar_today), // Placeholder icon
                        title: Text(_formatDate(forecast.date)), // Display only the date
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weather: ${forecast.weather.description}'),
                            Text('Temperature: ${forecast.weather.temperature.toStringAsFixed(1)}°C'),
                            Text('Humidity: ${forecast.weather.humidity}%'),
                            Text('Wind Speed: ${forecast.weather.windSpeed} m/s'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
