import 'package:flutter/material.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import 'componets/cart_header_screen.dart';
import 'componets/order_customer_list.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cartscreen';
  const CartScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CartSearchScreen(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OrderCustomerList(),
          ],
        ),
      ),
    );
  }
}
