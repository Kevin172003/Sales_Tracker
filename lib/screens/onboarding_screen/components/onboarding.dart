import 'package:flutter/material.dart';
import 'package:orderbook_flutter/constant/constant.dart';

Widget onBoarding({
  //required String image,
  required String title,
  required String subtitle,
  required BuildContext context,
}) =>
    MediaQuery.of(context).orientation == Orientation.landscape
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 7 8 SvgPicture.asset(image),
                const SizedBox(height: 30),
                Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: blue, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SvgPicture.asset(image),
              const SizedBox(height: 30),
              Container(
                color: backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  title,
                  style: TextStyle(
                      color: blue, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          );
