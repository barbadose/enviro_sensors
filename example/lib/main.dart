import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:enviro_sensors/enviro_sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // double _barometerReading;
  Stream<BarometerEvent> _pressureStream;
  Stream<LightmeterEvent> _lightmeterStream;
  Stream<AmbientTempEvent> _ambientTempStream;
  Stream<HumidityEvent> _humidityStream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // double barometerReading;
    Stream<BarometerEvent> pressureStream;
    Stream<LightmeterEvent> lightmeterStream;
    Stream<AmbientTempEvent> ambientTempStream;
    Stream<HumidityEvent> humidityStream;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      pressureStream = barometerEvents.asBroadcastStream();
      lightmeterStream = lightmeterEvents.asBroadcastStream();
      ambientTempStream = ambientTempEvents.asBroadcastStream();
      humidityStream = humidityEvents.asBroadcastStream();
      // barometerReading = await EnviroSensors.barometerReading;
    } on PlatformException {
      // barometerReading = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    _pressureStream = pressureStream;
    _lightmeterStream = lightmeterStream;
    _ambientTempStream = ambientTempStream;
    _humidityStream = humidityStream;
    setState(() {
      // _barometerReading = barometerReading;
    });
  }

  String _addUnitOfMeasurementSuffix(double prefix, String suffix) {
    return prefix.toStringAsFixed(1) + ' ' + suffix;
  }
  // Future<double> dispatchBarometerCall() async {
  //   double barometerReading;
  //   try {
  //     barometerReading = await EnviroSensors.barometerReading;
  //   } on PlatformException {
  //     barometerReading = null;
  //   }
  //   return barometerReading;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Enviro_Sensors')),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 35,
            ),
            // Barometer (stream and mathod-call button):
            Text('Barometer:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder(
                    stream: _pressureStream,
                    builder: (BuildContext context, dynamic snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return Text((snapshot.data.reading == null)
                            ? 'null'
                            : '${snapshot.data.reading.toStringAsFixed(1)} hPa');
                      }
                      return Text('Baromter stream value');
                    }),
                FlatButton(
                  child: Text('disabled'),
                  onPressed: null,
                  color: Colors.purpleAccent,
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 35,
            ),
            // Light sensor (stream and mathod-call button):
            Text('Light sensor:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder(
                    stream: _lightmeterStream,
                    builder: (BuildContext context, dynamic snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return Text((snapshot.data.reading == null)
                            ? 'null'
                            : '${snapshot.data.reading.toStringAsFixed(1)} lx');
                      }
                      return Text('Light sensor stream value');
                    }),
                FlatButton(
                  child: Text('disabled'),
                  onPressed: null,
                  color: Colors.purpleAccent,
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 35,
            ),
            // Ambient temp sensor (stream and mathod-call button):
            Text('Ambient temperature sensor:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder(
                    stream: _ambientTempStream,
                    builder: (BuildContext context, dynamic snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return Text((snapshot.data.reading == null)
                            ? 'null'
                            : '${snapshot.data.reading.toStringAsFixed(1)} °C');
                      }
                      return Text('Ambient temp stream value');
                    }),
                FlatButton(
                  child: Text('disabled'),
                  onPressed: null,
                  color: Colors.purpleAccent,
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 35,
            ),
            // Humidity sensor (stream and mathod-call button):
            Text('Humidity sensor:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder(
                    stream: _humidityStream,
                    builder: (BuildContext context, dynamic snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return Text((snapshot.data.reading == null)
                            ? 'null'
                            : '${snapshot.data.reading.toStringAsFixed(1)} %');
                      }
                      return Text('Humidity stream value');
                    }),
                FlatButton(
                  child: Text('disabled'),
                  onPressed: null,
                  color: Colors.purpleAccent,
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}
