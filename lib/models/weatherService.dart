import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  String? cityName;
  double? currentTemperature;
  double? maxTemperature;
  double? minTemperature;
  double? feelsLike;
  double? pressure;
  int? humidity;
  String? weatherMain;
  int? sunriseTime;
  int? sunsetTime;
  final http.Client httpClient;

  WeatherService(this.apiKey, {http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<void> getWeather(String city) async {
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=imperial&appid=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      cityName = weatherData['name'];
      currentTemperature = weatherData['main']['temp'].toDouble();
      maxTemperature = weatherData['main']['temp_max'].toDouble();
      minTemperature = weatherData['main']['temp_min'].toDouble();
      feelsLike = weatherData['main']['feels_like'].toDouble();
      pressure = weatherData['main']['pressure'].toDouble();
      humidity = weatherData['main']['humidity'];
      weatherMain = weatherData['weather'][0]['main'];
      sunriseTime = weatherData['sys']['sunrise'];
      sunsetTime = weatherData['sys']['sunset'];
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  List<double> fiveDayMainTemperatures = [];
  List<int> fiveDayTimestamps = [];

  Future<void> get5DayForecast(String city) async {
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=imperial&appid=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);

      cityName = weatherData['city']['name'];

      List<dynamic> list = weatherData['list'];

      // Clear previous data
      fiveDayMainTemperatures.clear();
      fiveDayTimestamps.clear();

      // Map to store the daily temperature
      Map<String, double> dailyTemperatureMap = {};

      for (var item in list) {
        double temperature = item['main']['temp'].toDouble();
        int timestamp = item['dt'];

        // Get the date in 'yyyy-MM-dd' format
        String date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
            .toLocal()
            .toString()
            .split(' ')[0];

        if (!dailyTemperatureMap.containsKey(date)) {
          dailyTemperatureMap[date] = temperature;
          fiveDayMainTemperatures.add(temperature);
          fiveDayTimestamps.add(timestamp);
        }
      }
    } else {
      throw Exception('Failed to load 5-day forecast data');
    }
  }
}
