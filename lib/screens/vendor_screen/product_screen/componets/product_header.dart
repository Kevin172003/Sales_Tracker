import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/constant.dart';

class ProductHeader extends StatefulWidget {
  const ProductHeader({super.key});

  @override
  State<ProductHeader> createState() => ProductHeaderState();
}

class ProductHeaderState extends State<ProductHeader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        backgroundColor: blue,
        elevation: 9,
        iconTheme: IconThemeData(color: white),
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
      ),
    );
  }
}
