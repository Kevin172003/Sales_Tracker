import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/constant.dart';

class CustomerHeader extends StatefulWidget {
  const CustomerHeader({super.key});

  @override
  State<CustomerHeader> createState() => CustomerHeaderState();
}

class CustomerHeaderState extends State<CustomerHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: white),
      backgroundColor: blue,
      title: Text(
        'Customer List',
        style: TextStyle(color: white),
      ),
      centerTitle: true,
      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: ClipOval(
            child: IconButton(
              icon: Icon(
                Icons.person,
                color: blue,
              ),
              onPressed: () {
                GoRouter.of(context).push('/profile');
              },
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
