import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import 'componets/order_header.dart';
import 'componets/order_list.dart';

class VendorOrderScreen extends StatelessWidget {
  const VendorOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: VendorOrderHeader(),
      ),
      body: VendorOrderList(),
    );
  }
}
