import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import '../../profile_screen/profilescreen.dart';

class BillScreenHeader extends StatefulWidget {
  const BillScreenHeader({super.key});

  @override
  State<BillScreenHeader> createState() => _BillScreenHeaderState();
}

class _BillScreenHeaderState extends State<BillScreenHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: blue,
      iconTheme: IconThemeData(color: white),
      centerTitle: true,
      title: Text(
        'Vendor List',
        style: TextStyle(color: white),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: white,
          child: ClipOval(
            child: IconButton(
              onPressed: () {
                GoRouter.of(context).push('/customervenorlist/customer-profile');
              },
              icon: Icon(
                Icons.person,
                color: blue,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
