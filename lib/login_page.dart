import 'dart:convert';
import 'dart:developer';

import 'package:facebook_login_app/facebook_auth_helper.dart';
import 'package:facebook_login_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              await _loginFacebook(context);
              // await _facebookLogin(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff4167b2),
            ),
            child: const Text(
              'Login with Facebook',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginFacebook(BuildContext context) async {
    await FacebookAuthHelper.clearFacebookSession(); // Clear Facebook session

    // Check if user is already logged in (potentially due to "Keep me logged in")
    final accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      // User is already logged in, navigate to home screen or handle accordingly
      //    final userData = accessToken.toMap();
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(
      //       userName: userData['name'] ?? 'User',
      //       profilePictureUrl: userData['picture']['data']['url'],
      //     ),
      //   ),
      // );
      log('Access token not null');
      return;
    }

    await _facebookLogin(
        context); // Perform login flow if not already logged in
  }

  Future<void> _facebookLogin(BuildContext context) async {
    // Log out the user first to ensure a fresh login session
    await FacebookAuth.instance.logOut();

    final result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken;
      log(accessToken.toString());

      // Retrieve user data from Facebook using Graph API
      final userData = await _fetchUserData(accessToken!);

      log(userData['name']);

      // Navigate to home screen with user data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userName: userData['name'] ?? 'User',
            profilePictureUrl: userData['picture']['data']['url'],
          ),
        ),
      );
    } else {
      _showErrorDialog(context, "Login failed: ${result.message}");
    }
  }

  Future<Map<String, dynamic>> _fetchUserData(AccessToken accessToken) async {
    final graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v13.0/me?fields=name,picture&access_token=${accessToken.token}'));
    return json.decode(graphResponse.body);
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
