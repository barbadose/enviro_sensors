import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enviro_sensors/enviro_sensors.dart';

void main() {
  const MethodChannel channel = MethodChannel('enviro_sensors');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await EnviroSensors.platformVersion, '42');
  // });
}
