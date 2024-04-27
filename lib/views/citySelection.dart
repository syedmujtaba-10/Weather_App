import 'package:flutter/material.dart';
import 'dart:ui';
/*import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../views/weatherDetails.dart';
import '../models/weatherService.dart';*/

class CitySelectionPage extends StatefulWidget {
  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  List<String> selectedCities = [];
  //Set<String> selectedCities = {};
  List<String> allCities = [
    'Tokyo',
    'New York City',
    'Mumbai',
    'Beijing',
    'Istanbul',
    'Cairo',
    'Moscow',
    'Rio de Janeiro',
    'Lagos',
    'London',
    'Karachi',
    'Mexico City',
    'Bangkok',
    'Seoul',
    'Sydney',
    'Los Angeles',
    'Buenos Aires',
    'Delhi',
    'Paris',
    'Jakarta',
    'Manila',
    'Cape Town',
    'Berlin',
    'Rome',
    'Toronto',
    'Nairobi',
    'Chicago',
    'Mumbai',
    'Shanghai',
    'Istanbul',
    'Dhaka',
    'Sao Paulo',
    'Hong Kong',
    'Riyadh',
    'Amsterdam',
    'Lima',
    'Bogotá',
    'Kuala Lumpur',
    'Singapore',
    'Hanoi',
    'Vancouver',
    'Athens',
    'Madrid',
    'Vienna',
    'Cairo',
    'Riyadh',
    'Oslo',
    'Warsaw',
    'Budapest',
    'Prague',
    'Calgary',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.cyan[800],
        elevation: 0,
        title: Text('Select Cities', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/mountains.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          ListView.builder(
            itemCount: allCities.length,
            itemBuilder: (context, index) {
              String cityName = allCities[index];
              bool isSelected = selectedCities.contains(cityName);

              return ListTile(
                title: Text(cityName, style: TextStyle(color: Colors.white)),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        if (value && !selectedCities.contains(cityName)) {
                          selectedCities = List.from(selectedCities)
                            ..add(cityName);
                        } else if (!value) {
                          selectedCities = List.from(selectedCities)
                            ..remove(cityName);
                        }
                      }
                    });
                  },
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedCities);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.cyan[800],
      ),
    );
  }
}
