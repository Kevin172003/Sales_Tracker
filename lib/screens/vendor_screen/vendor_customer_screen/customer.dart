import 'package:flutter/material.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import 'package:orderbook_flutter/screens/vendor_screen/vendor_customer_screen/componets/add_customer.dart';

import 'componets/customer_header.dart';
import 'componets/customer_list.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomerHeader(),
      ),
      body: CustomerListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddCustomer(
                onAddCustomer: () {},
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: blue,
        ),
        backgroundColor: white,
      ),
    );
  }
}
