import 'package:flutter/material.dart';
import 'package:orderbook_flutter/componets/buttons.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import 'package:orderbook_flutter/screens/vendor_screen/product_screen/api_call/createproduct_api.dart';

class Subcategory {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Subcategory();
  String get name => nameController.text;
  String get price => priceController.text;

  bool get isEmpty => name.isEmpty || price.isEmpty;
}

class CreateProduct extends StatefulWidget {
  final Function(String productName, List<Subcategory> subcategories)
      onAddProduct;

  CreateProduct({Key? key, required this.onAddProduct}) : super(key: key);

  @override
  CreateProductState createState() => CreateProductState();
}

class CreateProductState extends State<CreateProduct> {
  late TextEditingController productNameController;
  List<Subcategory> subcategories = [];
  bool isTextFieldEmpty = false;
  bool isproductNameEmpty = false;

  bool _cancelDeletion = false;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController();
    subcategories.add(Subcategory());
  }

  @override
  void dispose() {
    productNameController.dispose();
    for (var subcategory in subcategories) {
      subcategory.nameController.dispose();
      subcategory.priceController.dispose();
    }
    super.dispose();
  }

  void resetState() {
    setState(() {
      subcategories.clear();
      subcategories.add(Subcategory());
      productNameController.clear();
      isTextFieldEmpty = false;
      isproductNameEmpty = false;
    });
  }

  void validateAndAddProduct(BuildContext context) async {
    setState(() {
      isproductNameEmpty = productNameController.text.isEmpty;
      isTextFieldEmpty = subcategories.any((subcategory) => subcategory.isEmpty);
    });

    if (!isproductNameEmpty && !isTextFieldEmpty) {
      await addProduct(context, productNameController, subcategories);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Product Details'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Text(
            //   isTextFieldEmpty
            //       ? "Enter at least 1 subcategory with name and price"
            //       : "",
            //   style: TextStyle(color: Colors.red),
            // ),
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                hintText: 'Product Name',
                hintStyle: TextStyle(
                  color: isproductNameEmpty ? Colors.red : Colors.black54,
                ),
              ),
              style: TextStyle(
                color: isproductNameEmpty ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                for (int index = 0; index < subcategories.length; index++)
                  Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        if (!_cancelDeletion) {
                          setState(() {
                            subcategories.removeAt(index);
                          });
                        } else {
                          setState(() {
                            _cancelDeletion = false;
                          });
                        }
                      }
                    },
                    background: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete,color: blue,),
                            onPressed: () {
                              setState(() {
                                subcategories.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    child: buildSubcategoryRow(
                        subcategories[index], isTextFieldEmpty),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        CustomTextButton(
          onPressed: () {
            setState(() {
              subcategories.add(Subcategory());
            });
          },
          buttonText: 'Add Subcategory',
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextButton(
              onPressed: () {
                resetState();
                Navigator.of(context).pop();
              },
              buttonText: 'Close',
            ),
            const SizedBox(width: 10),
            CustomTextButton(
              onPressed: () {
                validateAndAddProduct(context);
              },
              buttonText: 'Create Product',
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSubcategoryRow(Subcategory subcategory, bool isTextFieldEmpty) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: subcategory.nameController,
            decoration: InputDecoration(
              labelText: 'Subcategory Name',
              labelStyle: TextStyle(
                color:
                    subcategory.nameController.text.isEmpty && isTextFieldEmpty
                        ? Colors.red
                        : Colors.black54,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: subcategory.priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              labelStyle: TextStyle(
                color:
                    subcategory.priceController.text.isEmpty && isTextFieldEmpty
                        ? Colors.red
                        : Colors.black54,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
