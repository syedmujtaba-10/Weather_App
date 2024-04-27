import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/weatherDetails.dart';
import '../models/weatherService.dart';
import 'citySelection.dart';
import 'dart:ui';
//import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> cities = [];
  Position? currentLocation;
  late WeatherService weatherService;
  String apiKey = "7377a150727bbde945ea90f292ba17c0";

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    weatherService = WeatherService(apiKey);
    loadCitiesFromPrefs();
  }

  Future<void> refreshWeatherData() async {
    if (cities.isNotEmpty) {
      await weatherService.getWeather(cities.first);
    }
  }

  Future<void> getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);

        if (mounted) {
          setState(() {
            currentLocation = position;
            addCityNameFromLocation(position.latitude, position.longitude);
          });
        }
      } catch (e) {
        print('Error getting current location: $e');
      }
    } else {
      print('Location permission denied');
    }
  }

  Future<void> addCityNameFromLocation(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        String cityName = placemarks.first.locality ?? 'Unknown City';
        if (!cities.contains(cityName)) {
          setState(() {
            cities.add(cityName);

            weatherService.getWeather(cityName);
            saveCitiesToPrefs();
          });
        }
      }
    } catch (e) {
      print('Error getting city name from location: $e');
    }
  }

  Future<void> loadCitiesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cities = prefs.getStringList('selectedCities') ?? [];
      removeDuplicateCities();
    });
  }

  Future<void> saveCitiesToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedCities', cities);
  }

  void deleteCity(int index) {
    setState(() {
      cities.removeAt(index);
      saveCitiesToPrefs();
    });
  }

  void removeDuplicateCities() {
    Set<String> uniqueCities = Set<String>.from(cities);
    setState(() {
      cities = uniqueCities.toList();
      saveCitiesToPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'City Weather List',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          flexibleSpace: Stack(
            children: [
              Positioned.fill(
                child: ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'assets/mountains.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.5),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 10,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () async {
                List<String>? selectedCities = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CitySelectionPage(),
                  ),
                );

                if (selectedCities != null && selectedCities.isNotEmpty) {
                  setState(() {
                    cities.addAll(selectedCities);
                    saveCitiesToPrefs();
                    loadCitiesFromPrefs();
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              color: Colors.white,
              onPressed: refreshWeatherData,
            ),
          ],
        ),
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/mountains.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ),
          ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(cities[index]),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      deleteCity(index);
                    });
                  }
                },
                background: Container(
                  alignment: AlignmentDirectional.centerStart,
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                /*child: FutureBuilder(
                  // Use FutureBuilder to fetch weather main for each city
                  future: weatherService.getWeather(cities[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for data, show a loading indicator
                      return ListTile(
                        title: Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      String weatherMain = weatherService.weatherMain ?? 'N/A';
                      //return CityCard(
                          cityName: cities[index], weatherMain: weatherMain);
                    }
                  },
                ),*/
                child: CityCard(cityName: cities[index]),
              );
            },
          ),
        ]));
  }
}

class CityCard extends StatelessWidget {
  final String cityName;
  //final String weatherMain;

  CityCard({required this.cityName});

  /*Widget getLottieAnimationForWeather(String weatherMain) {
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
        return Lottie.asset(
            'assets/sunny.json');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.withOpacity(0.2),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ListTile(
          title: Text(
            cityName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          //leading: getLottieAnimationForWeather(weatherMain),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeatherDetailsPage(
                  cityName: cityName,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
