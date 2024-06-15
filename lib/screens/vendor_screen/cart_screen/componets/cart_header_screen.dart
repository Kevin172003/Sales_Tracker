import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../constant/constant.dart';

class CartSearchScreen extends StatefulWidget {
  const CartSearchScreen({super.key});

  @override
  State<CartSearchScreen> createState() => _CartSearchScreenState();
}

class _CartSearchScreenState extends State<CartSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        title: Text(
          "Your Orders",
          style: TextStyle(color: white),
        ),
        backgroundColor: blue,
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: ClipOval(
              child: IconButton(
                icon: Icon(Icons.person,color: blue,),
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
      ),
    );
  }
}
