package com.example.facebook_login_app


import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import com.facebook.login.LoginManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.facebook_login_app/facebook_auth"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "clearFacebookSession") {
                clearFacebookSession()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun clearFacebookSession() {
        LoginManager.getInstance().logOut()
    }
}
