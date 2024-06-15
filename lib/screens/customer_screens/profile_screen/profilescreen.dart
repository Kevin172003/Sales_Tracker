import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import 'components/profilemenu.dart';
import 'components/profilepic.dart';
import 'api_call/logout_api.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  static String routeName = "/profile";

  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() => _ProfileScreenState();

}

class _ProfileScreenState extends ConsumerState<CustomerProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: blue,
        title: Text(
          "Profile",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        // 
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:size.height * 0.02),
            CustomerProfilePic(),
            // const SizedBox(height: 30),
            SizedBox(height:size.height  *0.04),
            CustomerProfileMenu(
              text: "My Account",
              iconData: Icons.account_circle,
              press: () {},
            ),
            CustomerProfileMenu(
              text: "Change Password",
              iconData: Icons.account_circle,
              press: () {
                // Navigator.push(context,MaterialPageRoute(builder: (context) => ChangePassScreen(),));
                GoRouter.of(context).push('/customervenorlist/customer-profile/customerchangePassword');
              },
            ),
            CustomerProfileMenu(
              text: "Settings",
              iconData: Icons.account_circle,
              press: () {},
            ),
            CustomerProfileMenu(
              text: "Help Center",
              iconData: Icons.account_circle,
              press: () {},
            ),
            CustomerProfileMenu(
              text: "Log Out",
              iconData: Icons.account_circle,
              press: () {
                logOut(context,ref);
              },
            ),
          ],
        ),
      ),
    );
  }
}
