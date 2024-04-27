import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mp5/models/weatherService.dart';
//import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:mockito/mockito.dart';

//import 'package:mockito/annotations.dart';

//import 'package:test/test.dart';
//import 'package:http/testing.dart';
//import 'package:http/http.dart' as http;

void main() {
  group('WeatherService', () {
    test('getWeather should populate weather information', () async {
      final weatherService = WeatherService('7377a150727bbde945ea90f292ba17c0');

      await weatherService.getWeather('Chicago');

      // Verify that weather information is populated correctly
      expect(weatherService.cityName, 'Chicago');
      expect(weatherService.currentTemperature, isNotNull);
      expect(weatherService.maxTemperature, isNotNull);
      expect(weatherService.minTemperature, isNotNull);
      expect(weatherService.feelsLike, isNotNull);
      expect(weatherService.pressure, isNotNull);
      expect(weatherService.humidity, isNotNull);
      expect(weatherService.weatherMain, isNotNull);
      expect(weatherService.sunriseTime, isNotNull);
      expect(weatherService.sunsetTime, isNotNull);
    });

    test('get5DayForecast should populate 5-day forecast information',
        () async {
      final weatherService = WeatherService('7377a150727bbde945ea90f292ba17c0');

      await weatherService.get5DayForecast('Beijing');

      // Verify that 5-day forecast information is populated correctly
      expect(weatherService.cityName, 'Beijing');
      expect(weatherService.fiveDayMainTemperatures,
          [isNotNull, isNotNull, isNotNull, isNotNull, isNotNull, anything]);
    });

    test('getWeather should handle API error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final weatherService = WeatherService('7377a150727bbde945ea90f292ba17c0',
          httpClient: mockClient);

      await expectLater(
        weatherService.getWeather('MockCity'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'error message',
            'Exception: Failed to load weather data')),
      );
    });

    test('getWeather should handle malformed API response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            '{"city":{"name":"MockCity"},"main":{},"weather":[{}],"sys":{}}',
            200);
      });

      final weatherService = WeatherService('7377a150727bbde945ea90f292ba17c0',
          httpClient: mockClient);

      await expectLater(
        weatherService.getWeather('MockCity'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'error message',
            'Exception: Failed to load weather data')),
      );
    });

    test('get5DayForecast should handle invalid 5-day forecast data', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            '{"city":{"name":"MockCity"},"list":[{"main":{"temp":"invalid"},"dt":1631165400},{"main":{"temp":30},"dt":1631251800}]}',
            200);
      });

      final weatherService = WeatherService('7377a150727bbde945ea90f292ba17c0',
          httpClient: mockClient);

      await expectLater(
        weatherService.get5DayForecast('MockCity'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'error message',
            'Exception: Failed to load 5-day forecast data')),
      );
    });
  });
}
