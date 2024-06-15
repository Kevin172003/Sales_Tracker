import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/onboarding.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  bool _onLastPage = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SizedBox(height: size.height*0.04,),
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(right: 22),
            child: TextButton(
              onPressed: () {
                GoRouter.of(context).go('/loginscreen');
              },
              child: Text(
                _onLastPage ? "" : 'Skip',
                style: TextStyle(color: blue),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          _onLastPage = value == 3;
                        });
                      },
                      children: [
                        onBoarding(
                          title: 'Welcome to SalesTracker!',
                          context: context,
                          subtitle:
                              'Easily add items to your inventory with just a few taps & Seamlessly manage your customer base and their purchases.',
                        ),
                        onBoarding(
                          title: 'Effortless Customer Management',
                          context: context,
                          subtitle:
                              'Create and store customer profiles for quick access & Assign items to specific customers for personalized service.',
                        ),
                        onBoarding(
                          title: 'Stay Organized with Invoices',
                          context: context,
                          subtitle:
                              'Track invoices for each customer to stay on top of transactions & Access detailed invoice history for better financial management.',
                        ),
                        onBoarding(
                          title: 'Simplified Inventory Management',
                          context: context,
                          subtitle:
                              'Add and categorize items effortlessly to streamline your inventory & Monitor stock levels and receive notifications for low inventory items.',
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: const Alignment(0, 0.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: ExpandingDotsEffect(activeDotColor: blue),
                        onDotClicked: (index) => _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _onLastPage
              ? InkWell(
                  onTap: () {
                    GoRouter.of(context).pushReplacementNamed('login');
                  },
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1,
                    color: blue,
                    child: Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: white),
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1,
                    color: blue,
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(color: white),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
