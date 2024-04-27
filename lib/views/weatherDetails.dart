import 'package:flutter/material.dart';
import '../models/weatherService.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

class WeatherDetailsPage extends StatefulWidget {
  final String cityName;

  WeatherDetailsPage({required this.cityName});

  @override
  _WeatherDetailsPageState createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  late WeatherService weatherService;
  String apiKey = "7377a150727bbde945ea90f292ba17c0";

  @override
  void initState() {
    super.initState();

    weatherService = WeatherService(apiKey);

    weatherService.getWeather(widget.cityName);
    weatherService.get5DayForecast(widget.cityName);
  }

  Future<void> refreshWeatherData() async {
    await weatherService.getWeather(widget.cityName);
  }

  Widget getLottieAnimationForWeather(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Lottie.asset('assets/sunny.json');
      case 'clouds':
        return Lottie.asset('assets/clouds.json');
      case 'rain':
        return Lottie.asset('assets/rain.json');
      case 'snow':
        return Lottie.asset('assets/snow.json');
      case 'thunderstorm':
        return Lottie.asset('assets/rain.json');
      case 'drizzle':
        return Lottie.asset('assets/rain.json');
      case 'mist':
        return Lottie.asset('assets/clouds.json');
      case 'fog':
        return Lottie.asset('assets/clouds.json');
      case 'smoke':
        return Lottie.asset('assets/clouds.json');
      case 'haze':
        return Lottie.asset('assets/clouds.json');
      case 'dust':
        return Lottie.asset('assets/clouds.json');
      case 'sand':
        return Lottie.asset('assets/clouds.json');
      default:
        return Lottie.asset('assets/sunny.json');
    }
  }

  Widget buildBlurredBackground(String imagePath, double blurSigma) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Weather Details - ${widget.cityName}'),
        backgroundColor: Colors.lightBlue[100],
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/snowy.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: weatherService.getWeather(widget.cityName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show a loading indicator while fetching data
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        double currentTemperature =
                            weatherService.currentTemperature ?? 0.0;
                        /*double maxTemperature =
                            weatherService.maxTemperature ?? 0.0;
                        double minTemperature =
                            weatherService.minTemperature ?? 0.0;*/
                        double feelsLike = weatherService.feelsLike ?? 0.0;
                        double pressure = weatherService.pressure ?? 0.0;
                        int humidity = weatherService.humidity ?? 0;
                        int? sunriseTime = weatherService.sunriseTime;
                        int? sunsetTime = weatherService.sunsetTime;
                        String? weatherMain = weatherService.weatherMain;
                        String formattedSunriseTime = DateFormat.Hm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              sunriseTime! * 1000),
                        );

                        String formattedSunsetTime = DateFormat.Hm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              sunsetTime! * 1000),
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            // Display Lottie animation based on weatherMain
                            Center(
                                child:
                                    getLottieAnimationForWeather(weatherMain!)),
                            Center(
                              child: Text(
                                '${currentTemperature.toInt()}°',
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Card(
                              margin: EdgeInsets.all(4),
                              color: Colors.blue.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Feels Like:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${feelsLike.toInt()}°',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.all(4),
                              color: Colors.blue.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Highs: ${weatherService.maxTemperature?.toInt()}°',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Lows: ${weatherService.minTemperature?.toInt()}°',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.all(4),
                              color: Colors.blue.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Pressure:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '$pressure',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.all(4),
                              color: Colors.blue.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Humidity:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '$humidity%',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.all(4),
                              color: Colors.blue.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Sunrise: $formattedSunriseTime',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Sunset: $formattedSunsetTime',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Card(
                              margin: EdgeInsets.all(8),
                              color: Colors.blue.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '5-Day Forecast',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    FutureBuilder(
                                      future: weatherService
                                          .get5DayForecast(widget.cityName),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          List<double> fiveDayMainTemperatures =
                                              weatherService
                                                  .fiveDayMainTemperatures;
                                          List<int> fiveDayTimestamps =
                                              weatherService.fiveDayTimestamps;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      fiveDayMainTemperatures
                                                          .length;
                                                  i++)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat('MMM d')
                                                            .format(
                                                          DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                            fiveDayTimestamps[
                                                                    i] *
                                                                1000,
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${fiveDayMainTemperatures[i].toInt()}°',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
