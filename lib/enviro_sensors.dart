import 'dart:async';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const EventChannel _barometerEventChannel = EventChannel('barometerStream');
const EventChannel _lightmeterEventChannel = EventChannel('lightmeterStream');
const EventChannel _ambientTempEventChannel = EventChannel('ambientTempStream');
const EventChannel _humidityEventChannel = EventChannel('humidityStream');

class BarometerEvent {
  BarometerEvent(this.reading);

  final double reading;

  @override
  String toString() => '$reading';
}

class LightmeterEvent {
  LightmeterEvent(this.reading);

  final double reading;

  @override
  String toString() => '$reading';
}

class AmbientTempEvent {
  AmbientTempEvent(this.reading);

  final double reading;

  @override
  String toString() => '$reading';
}

class HumidityEvent {
  HumidityEvent(this.reading);

  final double reading;

  @override
  String toString() => '$reading';
}

BarometerEvent _doubleToBarometerEvent(List<double> dbl) {
  return BarometerEvent(dbl[0]);
}

LightmeterEvent _doubleToLightmeterEvent(List<double> dbl) {
  return LightmeterEvent(dbl[0]);
}

AmbientTempEvent _doubleToAmbientTempEvent(List<double> dbl) {
  return AmbientTempEvent(dbl[0]);
}

HumidityEvent _doubleToHumidityEvent(List<double> dbl) {
  return HumidityEvent(dbl[0]);
}

Stream<BarometerEvent>? _barometerEvents;
Stream<LightmeterEvent>? _lightmeterEvents;
Stream<AmbientTempEvent>? _ambientTempEvents;
Stream<HumidityEvent>? _humidityEvents;

Stream<BarometerEvent> get barometerEvents {
  _barometerEvents ??= _barometerEventChannel
      .receiveBroadcastStream()
      .map((dynamic event) => _doubleToBarometerEvent(event.cast<double>()));
  return _barometerEvents!;
}

Stream<LightmeterEvent> get lightmeterEvents {
  _lightmeterEvents ??= _lightmeterEventChannel
      .receiveBroadcastStream()
      .map((dynamic event) => _doubleToLightmeterEvent(event.cast<double>()));
  return _lightmeterEvents!;
}

Stream<AmbientTempEvent> get ambientTempEvents {
  _ambientTempEvents ??= _ambientTempEventChannel
      .receiveBroadcastStream()
      .map((dynamic event) => _doubleToAmbientTempEvent(event.cast<double>()));
  return _ambientTempEvents!;
}

Stream<HumidityEvent> get humidityEvents {
  _humidityEvents ??= _humidityEventChannel
      .receiveBroadcastStream()
      .map((dynamic event) => _doubleToHumidityEvent(event.cast<double>()));
  return _humidityEvents!;
}


// class EnviroSensors {
//   static const MethodChannel _channel =
//       const MethodChannel('enviro_sensors');


//   static Future<String> get platformVersion async {
//     final String version = await _channel.invokeMethod('getPlatformVersion');
//     return version;
//   }

//   static Future<double> get barometerReading async {
//     final double reading = await _channel.invokeMethod('getBarometer');
//     return reading;
//   }

// }

