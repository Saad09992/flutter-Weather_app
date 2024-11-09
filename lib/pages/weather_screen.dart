// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../items/hourly_weather_cards.dart';
import '../items/add_info_weather_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String city = "gujranwala";
    String apiKey = "4a987832b369965dee971cc4cd773bf9";

    try {
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$apiKey"),
      );
      var decodedData = jsonDecode(res.body);
      if (decodedData['cod'] != '200') {
        throw 'Error fetching API response';
      }
      return decodedData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    print("init ran");
    getCurrentWeather();
  }

  String formatTimeTo12HourPKT(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    DateTime dateTimeInPKT = dateTime.toUtc().add(const Duration(hours: 5));

    String formattedTime = DateFormat('EEE | ha').format(dateTimeInPKT);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    print("built complete");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data!;
          final currentTemp = double.parse(
              (data['list'][0]['main']['temp'] - 273.15).toStringAsFixed(2));
          final humidity = data['list'][0]['main']['humidity'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final skyIcon = data['list'][0]['weather'][0]['main'];
          final pressure = data['list'][0]['main']['pressure'];
          final windSpeed = data['list'][0]['wind']['speed'];
          final hourlyLength = (data['list'].length - 1).toString();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$currentTemp° C',
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(
                              skyIcon == 'Rain' || skyIcon == "Clouds"
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Weather Forecast",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // weather time cards
                // TODO: use ListVIew instead of loop
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < int.parse(hourlyLength); i++)
                //         HourlyCards(
                //             icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                         "Clouds" ||
                //                     data['list'][i + 1]['weather'][0]['main'] ==
                //                         "Rain"
                //                 ? Icons.cloud
                //                 : Icons.sunny,
                //             temp:
                //                 '${double.parse((data['list'][i + 1]['main']['temp'] - 273.15).toStringAsFixed(2))}°',
                //             time: formatTimeTo12HourPKT(
                //                 data['list'][i + 1]['dt_txt'].toString())),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: int.parse(hourlyLength),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        IconData weatherIcon =
                            hourlyForecast['weather'][0]['main'] == 'Clouds'
                                ? Icons.cloud
                                : hourlyForecast['weather'][0]['main'] == 'Rain'
                                    ? Icons.umbrella
                                    : hourlyForecast['weather'][0]['main'] ==
                                            'Sunny'
                                        ? Icons.sunny
                                        : Icons.wb_sunny;

                        return HourlyCards(
                          icon: weatherIcon,
                          temp:
                              '${(hourlyForecast['main']['temp'] - 273.15).toStringAsFixed(2)}°',
                          time: formatTimeTo12HourPKT(
                              hourlyForecast['dt_txt'].toString()),
                        );
                      }),
                ),
                const SizedBox(height: 20),
                // additional info
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoCards(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: '${humidity.toString()} %'),
                    AdditionalInfoCards(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: '${windSpeed.toString()} m/s',
                    ),
                    AdditionalInfoCards(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: pressure.toString()),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
