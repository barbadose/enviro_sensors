package com.barbadose.enviro_sensors;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import android.content.Context;

import android.hardware.SensorManager;
import android.hardware.Sensor;
import static android.content.Context.SENSOR_SERVICE;

/** EnviroSensorsPlugin */
public class EnviroSensorsPlugin implements FlutterPlugin, MethodCallHandler {
  private static final String BAROMETER_CHANNEL_NAME = "barometerStream";
  private static final String LIGHTMETER_CHANNEL_NAME = "lightmeterStream";
  private static final String AMBIENT_TEMP_CHANNEL_NAME = "ambientTempStream";
  private static final String HUMIDITY_CHANNEL_NAME = "humidityStream";

  private EventChannel barometerChannel;
  private EventChannel lightmeterChannel;
  private EventChannel ambientTempChannel;
  private EventChannel humidityChannel;

  // private SensorManager mSensorManager;
  // private Sensor mBarometer;
  // private Registrar mRegistrar;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    final Context context = binding.getApplicationContext();
    final BinaryMessenger messenger = binding.getFlutterEngine().getDartExecutor();
    setupEventChannels(context, messenger);

    final MethodChannel channel = new MethodChannel(binding.getFlutterEngine().getDartExecutor(),
        "enviro_sensors");
    channel.setMethodCallHandler(new EnviroSensorsPlugin());
  }

  public static void registerWith(Registrar registrar) {
    EnviroSensorsPlugin plugin = new EnviroSensorsPlugin();
    plugin.setupEventChannels(registrar.context(), registrar.messenger());

    final MethodChannel channel = new MethodChannel(registrar.messenger(), "enviro_sensors");
    channel.setMethodCallHandler(new EnviroSensorsPlugin());
  }

  // double getBarometer() {
  //   mSensorManager = (SensorManager)(mRegistrar.activeContext().getSystemService(SENSOR_SERVICE));
  //   mBarometer = mSensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE);
  //   return 101325;
  // }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
      return;
    }
    // if (call.method.equals("getBarometer")) {
    //   double reading = getBarometer();
    //   result.success(reading);
    //   return;
    // }

    result.notImplemented();

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    teardownEventChannels();
  }

  private void setupEventChannels(Context context, BinaryMessenger messenger) {
    
    barometerChannel = new EventChannel(messenger, BAROMETER_CHANNEL_NAME);
    final StreamHandlerImpl barometerStreamHandler = new StreamHandlerImpl(
        (SensorManager) context.getSystemService(context.SENSOR_SERVICE), Sensor.TYPE_PRESSURE);
    barometerChannel.setStreamHandler(barometerStreamHandler);

    lightmeterChannel = new EventChannel(messenger, LIGHTMETER_CHANNEL_NAME);
    final StreamHandlerImpl lightmeterStreamHandler = new StreamHandlerImpl(
        (SensorManager) context.getSystemService(context.SENSOR_SERVICE), Sensor.TYPE_LIGHT);
    lightmeterChannel.setStreamHandler(lightmeterStreamHandler);

    ambientTempChannel = new EventChannel(messenger, AMBIENT_TEMP_CHANNEL_NAME);
    final StreamHandlerImpl ambientTempStreamHandler = new StreamHandlerImpl(
        (SensorManager) context.getSystemService(context.SENSOR_SERVICE), Sensor.TYPE_AMBIENT_TEMPERATURE);
    ambientTempChannel.setStreamHandler(ambientTempStreamHandler);

    humidityChannel = new EventChannel(messenger, HUMIDITY_CHANNEL_NAME);
    final StreamHandlerImpl humidityStreamHandler = new StreamHandlerImpl(
        (SensorManager) context.getSystemService(context.SENSOR_SERVICE), Sensor.TYPE_RELATIVE_HUMIDITY);
    humidityChannel.setStreamHandler(humidityStreamHandler);
 
  }

  private void teardownEventChannels() {
    barometerChannel.setStreamHandler(null);
  }
}
