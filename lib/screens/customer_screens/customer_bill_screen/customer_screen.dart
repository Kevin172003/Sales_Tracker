import 'package:flutter/material.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import '../contact.dart';
import 'componets/customer_header.dart';
import 'componets/customer_vendor_list.dart';

class CustomerVendorScreen extends StatefulWidget {
  const CustomerVendorScreen({super.key});

  @override
  State<CustomerVendorScreen> createState() => CustomerVendorScreenState();
}

class CustomerVendorScreenState extends State<CustomerVendorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: BillScreenHeader(),
      ),
      body: const CustomerVendorList(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigator.push(context,MaterialPageRoute(builder: (context) => LocationServices(),));
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: blue,
      //   ),
      //   backgroundColor: white,
      // ),
    );
  }
}
