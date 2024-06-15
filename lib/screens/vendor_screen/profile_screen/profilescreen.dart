import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/constant.dart';

import 'api_call/logout_api.dart';
import 'components/profilemenu.dart';
import 'components/profilepic.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Text(
          "Profile",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            ProfilePic(),
            // const SizedBox(height: 30),
            SizedBox(height: size.height * 0.04),

            ProfileMenu(
              text: "My Account",
              iconData: Icons.account_circle,
              press: () {},
            ),
            ProfileMenu(
              text: "Change Password",
              iconData: Icons.account_circle,
              press: () {
                // Navigator.push(context,MaterialPageRoute(builder: (context) => ChangePassScreen(),));
                GoRouter.of(context).push('/profile/changePassword');
              },
            ),
            ProfileMenu(
              text: "Settings",
              iconData: Icons.account_circle,
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              iconData: Icons.account_circle,
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              iconData: Icons.account_circle,
              press: () {
                logOut(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }
}
