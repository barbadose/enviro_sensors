# enviro_sensors

A plugin that in the future will facilitate calling the enviroment sensors on both 
android and iOS. 

Currently, only android pressure sensor stream is implemented.

## Getting Started

Install the package, import it and call the "barometerEvents" getter to instantiate a stream
of pressure events, see example/lib/main.dart for more. 

### TODO: 

- improve the interface for barometerEvents stream, add way to change SENSOR_DELAY if the device
    enables it.
- add barometerEvents stream on iOS.
- implement same API for temperature, light and humidity sensors.
- write docs and improve "example".
