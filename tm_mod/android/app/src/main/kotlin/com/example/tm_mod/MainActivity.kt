package com.example.tm_mod

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.tm_mod/service"

    companion object {
        var methodChannel: MethodChannel? = null
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler {
            call, result->
            if(call.method == "start") {
                CardLoadingService.start(context)
                result.success(null)
            } else {
                result.notImplemented()
            }
        };
    }

    override fun onDestroy() {
        super.onDestroy()
        CardLoadingService.stop(context)
    }

}
