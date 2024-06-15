import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, String?>> getAccessTokens() async {
    final String? refresh = await secureStorage.read(key: 'refresh');
    final String? access = await secureStorage.read(key: 'access');

    return {'refresh': refresh, 'access': access};
  }




  void whereToGo() async {
    final Map<String, String?> tokens = await getAccessTokens();

    final String? getAccessToken = tokens['access'];
    final String? getRefreshToken = tokens['refresh'];

    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedin = sharedPref.getBool('isLoggedIn') ?? false;
    print(isLoggedin);
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (isLoggedin != null && getAccessToken != null && getRefreshToken != null) {
          if (isLoggedin) {
            String? userType = sharedPref.getString('userType');
            if (userType == 'vendor') {
              GoRouter.of(context).go('/product');
            } else if (userType == 'customer') {
              GoRouter.of(context).go('/customervenorlist');
            } else {
              GoRouter.of(context).go('/OnBoardingScreen');
            }
            // GoRouter.of(context).go('/OnBoardingScreen');
          } else {
            GoRouter.of(context).go('/OnBoardingScreen');
          }
        } else {
          GoRouter.of(context).go('/OnBoardingScreen');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      body: Center(
        child: Text(
          'Order Book',
          style: TextStyle(
            color: white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
