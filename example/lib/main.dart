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
  String _platformVersion = 'Unknown';
  String _barometerReading = 'Unknown';
  Stream<BarometerEvent> _pressureStream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String barometerReading;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _pressureStream = barometerEvents.asBroadcastStream();
      platformVersion = await EnviroSensors.platformVersion;
      final tmpBarometerReading = await EnviroSensors.barometerReading;
      barometerReading = tmpBarometerReading.toString();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      barometerReading = 'Failed to get pressure reading';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _barometerReading = barometerReading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            // Center(
            //   child: Text('Pressure: $_barometerReading pascal'),
            // ),
            StreamBuilder(
                stream: _pressureStream,
                builder: (BuildContext context, dynamic snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text(
                          'Not connected to the stream or value == Null');
                    case ConnectionState.waiting:
                      return Text('awaiting interaction');
                    case ConnectionState.active:
                      return Text(
                        'Pressure: ${snapshot.data} hPa',
                        style: Theme.of(context).textTheme.display1,
                      );
                    case ConnectionState.done:
                      return Text('Stream has finished');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
