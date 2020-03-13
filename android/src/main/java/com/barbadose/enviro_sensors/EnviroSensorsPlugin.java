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

  private EventChannel barometerChannel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    final Context context = binding.getApplicationContext();
    final BinaryMessenger messenger = binding.getFlutterEngine().getDartExecutor();
    barometerChannel = new EventChannel(messenger, BAROMETER_CHANNEL_NAME);

    final StreamHandlerImpl barometerStreamHandler = new StreamHandlerImpl(
        (SensorManager) context.getSystemService(context.SENSOR_SERVICE), Sensor.TYPE_PRESSURE);
    barometerChannel.setStreamHandler(barometerStreamHandler);

    final MethodChannel channel = new MethodChannel(binding.getFlutterEngine().getDartExecutor(),
        "enviro_sensors");
    channel.setMethodCallHandler(new EnviroSensorsPlugin());
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "enviro_sensors");
    channel.setMethodCallHandler(new EnviroSensorsPlugin());
  }

  double getBarometer() {
    return 101325;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
      return;
    }
    if (call.method.equals("getBarometer")) {
      double reading = getBarometer();
      result.success(reading);
      return;
    }

    result.notImplemented();

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    teardownEventChannels();
  }

  private void teardownEventChannels() {
    barometerChannel.setStreamHandler(null);
  }
}
