import 'dart:async';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const EventChannel _barometerEventChannel = EventChannel('barometerStream');

class BarometerEvent {
  BarometerEvent(this.reading);

  final double reading;

  @override
  String toString() => '$reading';
}

BarometerEvent _doubleToBarometerEvent(List<double> dbl) {
  return BarometerEvent(dbl[0]);
}

Stream<BarometerEvent> _barometerEvents;

Stream<BarometerEvent> get barometerEvents {
  if (_barometerEvents == null) {
    _barometerEvents = _barometerEventChannel.receiveBroadcastStream().map((dynamic event)
    => _doubleToBarometerEvent(event.cast<double>()));
  }
  return _barometerEvents;
}

class EnviroSensors {
  static const MethodChannel _channel =
      const MethodChannel('enviro_sensors');


  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<double> get barometerReading async {
    final double reading = await _channel.invokeMethod('getBarometer');
    return reading;
  }

}

