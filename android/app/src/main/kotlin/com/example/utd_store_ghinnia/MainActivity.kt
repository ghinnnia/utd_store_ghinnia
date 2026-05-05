package com.example.utd_store_ghinnia

import android.os.BatteryManager
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "battery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getBattery") {
                    val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                    val batteryPercentage = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                    
                    if (batteryPercentage != -1) {
                        result.success(batteryPercentage)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}