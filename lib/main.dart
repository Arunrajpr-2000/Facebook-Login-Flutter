// import 'package:facebook_login_app/login_page.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const LoginPage(),
//     );
//   }
// }
// ==================================================================================================================================================================
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(const MyApp());
}

String prettyPrint(Map json) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  Future<void> _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance
          .getUserData(fields: "email,birthday,friends,gender,link");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  void _printCredentials() {
    print(
      prettyPrint(_accessToken!.toJson()),
    );
  }

  Future<void> _login() async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile

    // loginBehavior is only supported for Android devices, for ios it will be ignored
    // final result = await FacebookAuth.instance.login(
    //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
    //   loginBehavior: LoginBehavior
    //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    // );

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      _printCredentials();
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _userData = userData;
    } else {
      print(result.status);
      print(result.message);
    }

    setState(() {
      _checking = false;
    });
  }

  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth '),
        ),
        body: _checking
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _userData != null
                            ? prettyPrint(_userData!)
                            : "NO LOGGED",
                      ),
                      const SizedBox(height: 20),
                      _accessToken != null
                          ? Text(
                              prettyPrint(_accessToken!.toJson()),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      CupertinoButton(
                        color: Colors.blue,
                        onPressed: _userData != null ? _logOut : _login,
                        child: Text(
                          _userData != null ? "LOGOUT" : "LOGIN",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// =================================================================================================================================================================

// import 'package:flutter/material.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final plugin = FacebookLogin(debug: true);

//   MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHome(plugin: plugin),
//     );
//   }
// }

// class MyHome extends StatefulWidget {
//   final FacebookLogin plugin;

//   const MyHome({Key? key, required this.plugin}) : super(key: key);

//   @override
//   _MyHomeState createState() => _MyHomeState();
// }

// class _MyHomeState extends State<MyHome> {
//   FacebookAccessToken? _token;
//   FacebookUserProfile? _profile;
//   String? _email;
//   String? _imageUrl;

//   @override
//   void initState() {
//     super.initState();

//     _updateLoginInfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isLogin = _token != null && _profile != null;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Facebook Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               if (isLogin)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: _buildUserInfo(context, _profile!, _token!, _email),
//                 ),
//               isLogin
//                   ? OutlinedButton(
//                       child: const Text('Log Out'),
//                       onPressed: _onPressedLogOutButton,
//                     )
//                   : OutlinedButton(
//                       child: const Text('Log In'),
//                       onPressed: _onPressedLogInButton,
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUserInfo(BuildContext context, FacebookUserProfile profile,
//       FacebookAccessToken accessToken, String? email) {
//     final avatarUrl = _imageUrl;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (avatarUrl != null)
//           Center(
//             child: Image.network(avatarUrl),
//           ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             const Text('User: '),
//             Text(
//               '${profile.firstName} ${profile.lastName}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         const Text('AccessToken: '),
//         Text(
//           accessToken.token,
//           softWrap: true,
//         ),
//         if (email != null) Text('Email: $email'),
//       ],
//     );
//   }

//   Future<void> _onPressedLogInButton() async {
//     await widget.plugin.logIn(permissions: [
//       FacebookPermission.publicProfile,
//       FacebookPermission.email,
//     ]);
//     await _updateLoginInfo();
//   }

//   Future<void> _onPressedLogOutButton() async {
//     await widget.plugin.logOut();
//     await _updateLoginInfo();
//   }

//   Future<void> _updateLoginInfo() async {
//     final plugin = widget.plugin;
//     final token = await plugin.accessToken;
//     FacebookUserProfile? profile;
//     String? email;
//     String? imageUrl;

//     if (token != null) {
//       profile = await plugin.getUserProfile();
//       if (token.permissions.contains(FacebookPermission.email.name)) {
//         email = await plugin.getUserEmail();
//       }
//       imageUrl = await plugin.getProfileImageUrl(width: 100);
//     }

//     setState(() {
//       _token = token;
//       _profile = profile;
//       _email = email;
//       _imageUrl = imageUrl;
//     });
//   }
// }
