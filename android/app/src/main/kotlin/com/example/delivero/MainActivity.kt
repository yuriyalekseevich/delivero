package com.example.delivero

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {

    private val METHOD_CHANNEL = "com.example.device_info/methods"
    private val EVENT_CHANNEL = "com.example.device_info/events"

    private var batteryStateReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // -------------------------------
        // MethodChannel for one-time calls
        // -------------------------------
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getBatteryLevel" -> {
                        val level = getBatteryLevel()
                        if (level != -1) result.success(level)
                        else result.error("UNAVAILABLE", "Battery info not available", null)
                    }
                    else -> result.notImplemented()
                }
            }

        // -------------------------------
        // EventChannel for battery state updates
        // -------------------------------
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    batteryStateReceiver = createBatteryReceiver(events)
                    registerReceiver(
                        batteryStateReceiver,
                        IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                    )
                }

                override fun onCancel(arguments: Any?) {
                    batteryStateReceiver?.let { unregisterReceiver(it) }
                    batteryStateReceiver = null
                }
            })
    }

    // -------------------------------
    // Helper: Get current battery level
    // -------------------------------
    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        else -1
    }

    // -------------------------------
    // Helper: BroadcastReceiver for battery state
    // -------------------------------
    private fun createBatteryReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                intent?.let {
                    val status = it.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                    val state = when(status) {
                        BatteryManager.BATTERY_STATUS_CHARGING -> "charging"
                        BatteryManager.BATTERY_STATUS_FULL -> "full"
                        BatteryManager.BATTERY_STATUS_DISCHARGING -> "discharging"
                        BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "not_charging"
                        else -> "unknown"
                    }
                    events?.success(state)
                }
            }
        }
    }
}
