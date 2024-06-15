import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/route/route_error_screen.dart';
import '../screens/authentication/login_screen/componets/change_password.dart';
import '../screens/authentication/login_screen/componets/forget_password_screen.dart';
import '../screens/authentication/login_screen/login_screen.dart';
import '../screens/customer_screens/customer_bill_screen/componets/customer_invoice.dart';
import '../screens/customer_screens/customer_bill_screen/componets/customer_order_list.dart';
import '../screens/customer_screens/customer_bill_screen/customer_screen.dart';
import '../screens/customer_screens/profile_screen/profilescreen.dart';
import '../screens/onboarding_screen/onboarding_screen.dart';
import '../screens/splash_screen/splash_screen.dart';
import '../screens/vendor_screen/bottomNavigationBar.dart';
import '../screens/vendor_screen/cart_screen/cart.dart';
import '../screens/vendor_screen/cart_screen/componets/cart_list.dart';
import '../screens/vendor_screen/product_screen/componets/subproduct_list.dart';
import '../screens/vendor_screen/product_screen/product.dart';
import '../screens/vendor_screen/profile_screen/profilescreen.dart';
import '../screens/vendor_screen/vendor_customer_screen/componets/customer_product_list.dart';
import '../screens/vendor_screen/vendor_customer_screen/componets/product_subcategory_list.dart';
import '../screens/vendor_screen/vendor_customer_screen/customer.dart';
import '../screens/vendor_screen/vendor_order_details_screen/componets/vendor_invoice.dart';
import '../screens/vendor_screen/vendor_order_details_screen/vendor_order.dart';
import 'go_router_notifier.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigator,
    initialLocation: '/',
    refreshListenable: notifier,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'onboardingscreen',
        path: '/OnBoardingScreen',
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        name: 'login',
        path: '/loginscreen',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forrgetpassword',
        builder: (context, state) => const ForgetPassScreen(),
      ),
      GoRoute(
        path: '/customervenorlist',
        pageBuilder: (context, state) {
          return NoTransitionPage(
              child: CustomerVendorScreen(
                key: state.pageKey,
              ));
          },
        routes: [
          GoRoute(
              path:'customer-profile',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                  child: CustomerProfileScreen(
                    key: state.pageKey,
                  )
              );
            },
             routes: [
                GoRoute(
                  path: 'customerchangePassword',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      child: ChangePassScreen(
                        key: state.pageKey,
                      ),
                    );
                  },
                ),
              ],
          ),
          GoRoute(
              path: 'customer-vendor-orderist/:vendorID',
            pageBuilder: (context, state) {
              final vendorID =
              state.pathParameters['vendorID'].toString();
              return NoTransitionPage(
                  child: CustomerOrderList(
                    vendorID:vendorID,
                    key: state.pageKey,
                  ),
              );
            },
            routes: [
              GoRoute(
                path: 'invoice/:orderId',
                pageBuilder: (context, state) {
                  final orderId =
                  state.pathParameters['orderId'].toString();
                  return NoTransitionPage(
                    child: CustomerInvoiceScreen(
                      orderId:orderId,
                      key: state.pageKey,
                    ),
                  );
                },
              ),

            ],
          ),
        ]
      ),
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) =>
              BottomNavBar(key: state.pageKey, child: child),
          routes: [
            GoRoute(
                path: '/product',
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: ProductScreen(
                    key: state.pageKey,
                  ));
                },
                routes: [
                  GoRoute(
                      parentNavigatorKey: _shellNavigator,
                      path: 'subProduct/:productID',
                      pageBuilder: (context, state) {
                        final productID =
                            state.pathParameters['productID'].toString();
                        return NoTransitionPage(
                            child: SubProductList(
                          productID: productID,
                          key: state.pageKey,
                        ));
                      }),
                ]),
            GoRoute(
                path: '/customer',
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: CustomerScreen(
                    key: state.pageKey,
                  ));
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: _shellNavigator,
                    path: 'customerProduct/:customerId',
                    pageBuilder: (context, state) {
                      final customerId =
                          state.pathParameters['customerId'].toString();
                      return NoTransitionPage(
                          child: CustomerProductList(
                        customerID: customerId,
                        key: state.pageKey,
                      ));
                    },
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _shellNavigator,
                        path: 'customerSubProduct/:customerId/:productId',
                        pageBuilder: (context, state) {
                          final customerId =
                              state.pathParameters['customerId'].toString();
                          final productId =
                              state.pathParameters['productId'].toString();
                          return NoTransitionPage(
                              child: ProductSubcategory(
                            customerID: customerId,
                            productID: productId,
                            key: state.pageKey,
                          ));
                        },
                      ),
                    ],
                  ),
                ]),
            GoRoute(
              path: '/cart',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: CartScreen(
                  key: state.pageKey,
                ));
              },
              routes: [
                GoRoute(
                    parentNavigatorKey: _shellNavigator,
                    path: 'catlist/:customerId/:cartId',
                    pageBuilder: (context, state) {
                      final customerId =
                          state.pathParameters['customerId'].toString();
                      final cartId = state.pathParameters['cartId'].toString();
                      return NoTransitionPage(
                          child: CartListScreen(
                        customerID: customerId,
                        cartID: cartId,
                        key: state.pageKey,
                      ));
                    }),
              ],
            ),
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: ProfileScreen(
                  key: state.pageKey,
                ));
              },
              routes: [
                GoRoute(
                  parentNavigatorKey: _shellNavigator,
                  path: 'changePassword',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      child: ChangePassScreen(
                        key: state.pageKey,
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
                path: '/vendororder',
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: VendorOrderScreen(
                    key: state.pageKey,
                  ));
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: _shellNavigator,
                    path: 'orderinvoice/:orderId',
                    pageBuilder: (context, state) {
                      final orderId = state.pathParameters['orderId'].toString();
                      return NoTransitionPage(
                        child: VendorInvoiceScreen(
                          orderId:orderId,
                          key: state.pageKey,
                        ),
                      );
                    },
                  ),
                ]),
          ])
    ],
    errorBuilder: (context, state) => RouteErrorScreen(
      errorMsg: state.error.toString(),
      key: state.pageKey,
    ),
  );
});
