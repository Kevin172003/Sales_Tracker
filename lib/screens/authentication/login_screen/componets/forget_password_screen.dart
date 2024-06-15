import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/constant.dart';
import 'otp_screen.dart';



class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  confirm_dialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Text('Are you sure?'),
          actions: [const Text('ok')],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Forget Password",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        backgroundColor: blue,
        iconTheme: IconThemeData(color: white),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              Container(
                height: 150,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.elliptical(500, 190),
                  ),
                ),
                // child: Container(
                //   padding: const EdgeInsets.all(15),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "We'll help you !",
                //       style: TextStyle(
                //           color: white,
                //           fontSize: 30,
                //           fontWeight: FontWeight.w100),
                //     ),
                //   ),
                // ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 150, left: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                          hintText: 'Enter PhoneNumber',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Get.to(() => const OtpScreen());
                      },
                      height: 50,
                      color: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       //confirm_dialog();
                //       Get.to(() => const OtpScreen());
                //     },
                //     style: ButtonStyle(
                //         backgroundColor:
                //             MaterialStatePropertyAll(darkPurple)),
                //     child: Text(
                //       'Confirm',
                //       style: TextStyle(color: white),
                //     )),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
