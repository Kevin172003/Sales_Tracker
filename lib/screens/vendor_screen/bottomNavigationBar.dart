import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constant/constant.dart';

final BottomNavBarControllerProvider =
    StateNotifierProvider<BottomNavBarController, int>((ref) {
  return BottomNavBarController(0);
});

class BottomNavBarController extends StateNotifier<int> {
  BottomNavBarController(super.state);

  void setPosition(int value) {
    state = value;
  }
}

class BottomNavBar extends ConsumerStatefulWidget {
  final Widget child;
  const BottomNavBar({Key? key, required this.child}) : super(key: key);

  @override
  ConsumerState<BottomNavBar> createState() =>
      _CombinedBottomNavigationWidgetState();
}

class _CombinedBottomNavigationWidgetState extends ConsumerState<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final position = ref.watch(BottomNavBarControllerProvider);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: orange,
        unselectedItemColor: white,
        backgroundColor: blue,
        showUnselectedLabels: true,
        currentIndex: position,
        onTap: (value) => _onTap(value, context),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cube_box),
            label: 'Product',
            backgroundColor: blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group_solid),
            label: 'Customer',
            backgroundColor: blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'Cart',
            backgroundColor: blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            label: 'orders',
            backgroundColor: blue,
          ),
        ],
      ),
    );
  }

  void _onTap(int index, BuildContext context) {
    ref.read(BottomNavBarControllerProvider.notifier).setPosition(index);

    switch (index) {
      case 0:
        context.go('/product');
        break;
      case 1:
        context.go('/customer');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/vendororder');
        break;
    }
  }
}
