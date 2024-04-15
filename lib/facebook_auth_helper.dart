import 'package:flutter/services.dart';

class FacebookAuthHelper {
  static const platform =
      MethodChannel('com.example.facebook_login_app/facebook_auth');

  static Future<void> clearFacebookSession() async {
    try {
      await platform.invokeMethod('clearFacebookSession');
    } on PlatformException catch (e) {
      print("Failed to clear Facebook session: '${e.message}'.");
    }
  }
}
