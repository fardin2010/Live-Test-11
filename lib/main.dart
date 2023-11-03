import 'dart:convert';
import 'package:flutter/material.dart';

class CityWeather {
  final String city;
  final double temperature;
  final String condition;
  final double humidity;
  final double windSpeed;

  CityWeather(this.city, this.temperature, this.condition, this.humidity,
      this.windSpeed);

  factory CityWeather.fromJson(Map<String, dynamic> json) {
    return CityWeather(
      json['city'], json['temperature'], json['condition'], json['humidity'],
      json['windSpeed'],
    );
  }
}

Future<List<CityWeather>> parseWeatherData(String jsonString) async {
  final jsonDecoded = jsonDecode(jsonString) as List<dynamic>;
  final weatherData = jsonDecoded.map((dynamic json) {
    return CityWeather.fromJson(json);
  }).toList();

  return weatherData;
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CityWeather>>(
      future: parseWeatherData(jsonString),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final weatherData = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text('Weather Info'),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/weather_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                itemCount: weatherData.length,
                itemBuilder: (context, index) {
                  final cityWeather = weatherData[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(cityWeather.city,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              )),
                          Text('${cityWeather.temperature} °C'),
                          Text(cityWeather.condition),
                          Text('Humidity: ${cityWeather.humidity} %'),
                          Text('Wind speed: ${cityWeather.windSpeed} m/s'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

const jsonString = '''
[
  {
    "city": "New York",
    "temperature": 20,
    "condition": "Clear",
    "humidity": 60,
    "windSpeed": 5.5
  },
  {
    "city": "Los Angeles",
    "temperature": 25,
    "condition": "Sunny",
    "humidity": 50,
    "windSpeed": 6.8
  },
  {
    "city": "London",
    "temperature": 15,
    "condition": "Partly Cloudy",
    "humidity": 70,
    "windSpeed": 4.2
  },
  {
    "city": "Tokyo",
    "temperature": 28,
    "condition": "Rainy",
    "humidity": 75,
    "windSpeed": 8.0
  },
  {
    "city": "Sydney",
    "temperature": 22,
    "condition": "Cloudy",
    "humidity": 55,
    "windSpeed": 7.3
  }
]
''';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WeatherApp(),
  ));
}
