import 'package:flutter/material.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import 'package:orderbook_flutter/screens/vendor_screen/product_screen/componets/create_product_popup.dart';
import 'componets/product_header.dart';
import 'componets/product_list.dart';

class ProductScreen extends StatelessWidget {
  static String routeName = '/product';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: ProductHeader(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProductListScreen(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              //To create Productsa
              return CreateProduct(
                onAddProduct:
                    (String productName, List<Subcategory> subcategories) {
                  print('Product Name: $productName');
                  print('Subcategories: $subcategories');
                },
              );
            },
          );
        },
        backgroundColor: white,
        child: Icon(
          Icons.add,
          color: blue,
        ),
      ),
    );
  }
}
