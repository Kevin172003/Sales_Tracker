import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../constant/constant.dart';


class VendorOrderHeader extends StatelessWidget {
  const VendorOrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: white),
      backgroundColor: blue,
      title: Text(
        'Order List',
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
