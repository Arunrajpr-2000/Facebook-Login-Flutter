import 'package:facebook_login_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final String? profilePictureUrl;

  const HomeScreen({required this.userName, this.profilePictureUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
              onPressed: () async {
                await FacebookAuth.instance.logOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (profilePictureUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(profilePictureUrl!),
                radius: 50,
              ),
            const SizedBox(height: 20),
            Text('Welcome, $userName!'),
          ],
        ),
      ),
    );
  }
}
